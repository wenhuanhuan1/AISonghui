//
//  WHHAIInAppPurchaseV2Manager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/12.
//
import StoreKit
import UIKit

class WHHAIInAppPurchaseV2Manager: NSObject {
    static let shared = WHHAIInAppPurchaseV2Manager()
    private var purchasingProductID: String?
    private(set) var purchaseProduct: Product?

    /// 创建订单
    func inAppPurchaseV2ManagerCreateOrder(goodsId: String,
                                           payPage: String = "VIP",
                                           callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }
            if code == 1 {
                self.inAppPurchaseV2ManagerStartPurchasing(
                    productID: model.goodsCode,
                    userUUID: model.uuid,
                    orderId: model.orderId,
                    callBack: callBack
                )
            } else {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
                callBack?(false, "请求失败")
            }
        }
    }

    /// 开始购买
    private func inAppPurchaseV2ManagerStartPurchasing(productID: String,
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
                let result = try await storeProduct.purchase(
                    options: [.appAccountToken(UUID(uuidString: userUUID)!)]
                )

                purchasingProductID = nil

                switch result {
                case let .success(verification):
                    let transaction = try checkVerified(verification)

                    // 3️⃣ 完成交易
                    await transaction.finish()

                    // 4️⃣ 确保收据存在
                    try await ensureReceiptExists()

                    // 5️⃣ 上传最新收据
                    try await uploadLatestReceipt(orderId: orderId)

                    callBack?(true, "支付成功")

                case .userCancelled:
                    // 用户取消购买也刷新收据
                    try? await refreshReceipt()
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "用户取消购买")

                case .pending:
                    // 购买待处理也刷新收据
                    try? await refreshReceipt()
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "购买待处理")

                @unknown default:
                    // 未知状态也刷新收据
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

    // MARK: - 验证交易签名

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case let .verified(safe):
            return safe
        case .unverified:
            throw NSError(domain: "iap.verify.failed", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "交易验证失败"])
        }
    }

    // MARK: - 确保收据存在（自动刷新）

    private func ensureReceiptExists() async throws {
        let appStoreReceiptURL = Bundle.main.appStoreReceiptURL
        if appStoreReceiptURL == nil || !FileManager.default.fileExists(atPath: appStoreReceiptURL!.path) {
            try await refreshReceipt()
            return
        }
        let data = try Data(contentsOf: appStoreReceiptURL!)
        if data.isEmpty {
            try await refreshReceipt()
        }
    }

    private func refreshReceipt() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let request = SKReceiptRefreshRequest()
            request.delegate = ReceiptRequestDelegate { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "iap.receipt", code: -2,
                                                                   userInfo: [NSLocalizedDescriptionKey: "刷新收据失败"]))
                }
            }
            request.start()
        }
    }

    // MARK: - 上传最新收据

    private func uploadLatestReceipt(orderId: String) async throws {
        try await ensureReceiptExists() // 确保最新收据存在

        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: appStoreReceiptURL),
              !receiptData.isEmpty else {
            WHHHUD.whhHidenLoadView()
            throw NSError(domain: "iap.receipt.empty", code: -3,
                          userInfo: [NSLocalizedDescriptionKey: "本地票据为空，请重试或恢复购买"])
        }

        let base64Receipt = receiptData.base64EncodedString()
        try await withCheckedThrowingContinuation { continuation in
            FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(orderId: orderId, receiptData: base64Receipt) { success, _ in
                WHHHUD.whhHidenLoadView()
                if success == 1 {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: NSError(domain: "iap.upload.failed", code: -4,
                                                          userInfo: [NSLocalizedDescriptionKey: "支付验证上传失败"]))
                }
            }
        }
    }
}

// MARK: - 收据刷新代理封装

private class ReceiptRequestDelegate: NSObject, SKRequestDelegate {
    private let completion: (Bool, Error?) -> Void

    init(_ completion: @escaping (Bool, Error?) -> Void) {
        self.completion = completion
    }

    func requestDidFinish(_ request: SKRequest) {
        completion(true, nil)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        completion(false, error)
    }
}
