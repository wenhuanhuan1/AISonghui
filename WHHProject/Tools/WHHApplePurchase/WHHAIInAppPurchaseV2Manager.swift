import StoreKit
import UIKit

/// V2 内购管理器（保证使用最新收据）
class WHHAIInAppPurchaseV2ManagerV2: NSObject {
    static let shared = WHHAIInAppPurchaseV2ManagerV2()
    private var purchasingProductID: String?
    private(set) var purchaseProduct: Product?

    /// 超时时间（秒）
    private let receiptUploadTimeout: TimeInterval = 15

    // MARK: - 创建订单

    func createOrder(goodsId: String,
                     payPage: String = "VIP",
                     callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }
            if code == 1 {
                self.startPurchasing(
                    productID: model.goodsCode,
                    userUUID: model.uuid,
                    orderId: model.orderId,
                    callBack: callBack
                )
            } else {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) { WHHHUD.whhShowInfoText(text: msg) }
                callBack?(false, "请求失败")
            }
        }
    }

    // MARK: - 开始购买

    private func startPurchasing(productID: String,
                                 userUUID: String,
                                 orderId: String,
                                 callBack: ((Bool, String) -> Void)?) {
        Task {
            do {
                // 1️⃣ 获取商品
                guard let storeProduct = try await Product.products(for: [productID]).first else {
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "未找到商品")
                    return
                }
                purchasingProductID = productID

                // 2️⃣ 发起购买
                let result = try await storeProduct.purchase(options: [.appAccountToken(UUID(uuidString: userUUID)!)])
                purchasingProductID = nil

                switch result {
                case let .success(verification):
                    let transaction = try checkVerified(verification)
                    await transaction.finish()

                    // 确保收据存在
                    try await ensureReceiptExists()

                    // 上传收据带超时
                    do {
                        try await uploadLatestReceipt(orderId: orderId, timeout: receiptUploadTimeout)
                        callBack?(true, "支付成功")
                    } catch {
                        callBack?(false, error.localizedDescription)
                    }
                    WHHHUD.whhHidenLoadView()

                case .userCancelled:
                    try? await refreshReceipt()
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "用户取消购买")

                case .pending:
                    try? await refreshReceipt()
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "购买待处理")

                @unknown default:
                    try? await refreshReceipt()
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "未知购买状态")
                }
            } catch {
                WHHHUD.whhHidenLoadView()
                purchasingProductID = nil
                callBack?(false, "购买失败：\(error.localizedDescription)")
            }
        }
    }

    // MARK: - 验证交易

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case let .verified(safe): return safe
        case .unverified: throw NSError(domain: "iap.verify.failed", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "交易验证失败"])
        }
    }

    // MARK: - 收据处理

    private func ensureReceiptExists() async throws {
        let url = Bundle.main.appStoreReceiptURL
        if url == nil || !FileManager.default.fileExists(atPath: url!.path) {
            try await refreshReceipt()
            return
        }
        let data = try Data(contentsOf: url!)
        if data.isEmpty { try await refreshReceipt() }
    }

    private func refreshReceipt() async throws {
        try await withCheckedThrowingContinuation { continuation in
            let request = SKReceiptRefreshRequest()
            request.delegate = ReceiptRequestDelegate { success, error in
                if success { continuation.resume() }
                else { continuation.resume(throwing: error ?? NSError(domain: "iap.receipt", code: -2,
                                                                      userInfo: [NSLocalizedDescriptionKey: "刷新收据失败"])) }
            }
            request.start()
        }
    }

    // MARK: - 上传最新收据（带超时）

    private func uploadLatestReceipt(orderId: String, timeout: TimeInterval) async throws {
        try await ensureReceiptExists()
        guard let url = Bundle.main.appStoreReceiptURL,
              let data = try? Data(contentsOf: url),
              !data.isEmpty else {
            throw NSError(domain: "iap.receipt.empty", code: -3,
                          userInfo: [NSLocalizedDescriptionKey: "本地票据为空"])
        }
        let base64 = data.base64EncodedString()

        try await withThrowingTaskGroup(of: Void.self) { group in
            // 上传任务
            group.addTask {
                try await withCheckedThrowingContinuation { continuation in
                    FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(orderId: orderId, receiptData: base64) { success, _ in
                        if success == 1 { continuation.resume() }
                        else { continuation.resume(throwing: NSError(domain: "iap.upload.failed", code: -4,
                                                                     userInfo: [NSLocalizedDescriptionKey: "支付验证上传失败"])) }
                    }
                }
            }

            // 超时任务
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1000000000))
                throw NSError(domain: "iap.upload.timeout", code: -5,
                              userInfo: [NSLocalizedDescriptionKey: "上传收据超时"])
            }

            // 等待任意一个完成
            try await group.next()!
            group.cancelAll()
        }
    }
}

// MARK: - 收据刷新代理

private class ReceiptRequestDelegate: NSObject, SKRequestDelegate {
    private let completion: (Bool, Error?) -> Void
    init(_ completion: @escaping (Bool, Error?) -> Void) { self.completion = completion }
    func requestDidFinish(_ request: SKRequest) { completion(true, nil) }
    func request(_ request: SKRequest, didFailWithError error: Error) { completion(false, error) }
}
