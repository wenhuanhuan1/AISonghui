import Foundation
import StoreKit
import UIKit

/// 自定义错误类型
enum WHHStoreKitError: LocalizedError {
    case productNotFound
    case purchaseFailed(String)
    case verificationFailed
    case receiptEmpty
    case uploadFailed(String)
    case uploadTimeout
    case restoreFailed(String)
    var errorDescription: String? {
        switch self {
        case .productNotFound: return "未找到商品"
        case let .purchaseFailed(s): return "购买失败：\(s)"
        case .verificationFailed: return "交易验证失败"
        case .receiptEmpty: return "本地票据为空"
        case let .uploadFailed(s): return "收据上传失败：\(s)"
        case .uploadTimeout: return "收据上传超时"
        case let .restoreFailed(s): return "恢复购买失败：\(s)"
        }
    }
}

/// StoreKit v2 管理器（V2）
final class WHHStoreKitManagerV2 {
    static let shared = WHHStoreKitManagerV2()

    private init() { }

    /// 默认收据上传超时（秒）
    private let uploadTimeout: TimeInterval = 30

    private var purchasingProductID: String?
    /// 强持有正在进行的收据刷新委托，避免被提前释放导致回调丢失
    private var activeReceiptDelegates: [ReceiptRequestDelegate] = []
    /// 长驻任务：监听交易更新，避免漏单
    private var transactionUpdatesTask: Task<Void, Never>?
    /// 购买时暂存 productID -> orderId，用于交易更新回补上传
    private var pendingOrderIdByProductId: [String: String] = [:]

    // MARK: - 创建订单

    func createOrder(goodsId: String,
                     payPage: String = "VIP",
                     callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }
            if code == 1 {
                // 记录 productID 与对应的业务 orderId，便于 Transaction.updates 回补
                self.pendingOrderIdByProductId[model.goodsCode] = model.orderId
                self.purchase(productID: model.goodsCode, userUUID: model.uuid, orderId: model.orderId) { success, msg in
                    callBack?(success, msg)
                }
            } else {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) { WHHHUD.whhShowInfoText(text: msg) }
                callBack?(false, "请求失败")
            }
        }
    }

    // MARK: - 公共API（回调版本，便于 Objective-C / UIKit 使用）

    /// 发起购买（回调）
    /// - Parameters:
    ///   - productID: 商品 id
    ///   - userUUID: 用户 uuid（用于 appAccountToken）
    ///   - orderId: 你服务器的订单 id，用于上传收据
    ///   - completion: (success, message)
    func purchase(productID: String,
                  userUUID: String,
                  orderId: String,
                  completion: @escaping (Bool, String) -> Void) {
        Task {
            do {
                try await purchaseAsync(productID: productID, userUUID: userUUID, orderId: orderId)
                WHHHUD.whhHidenLoadView()
                completion(true, "支付成功")
            } catch {
                WHHHUD.whhHidenLoadView()
                
                debugPrint("sasasasasasasas\(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
            }
        }
    }

    // MARK: - 异步实现（async/await）

    /// 异步购买主流程
    func purchaseAsync(productID: String, userUUID: String, orderId: String) async throws {
        // 1. 查询商品
        guard let skProduct = try await Product.products(for: [productID]).first else {
            WHHHUD.whhHidenLoadView()
            throw WHHStoreKitError.productNotFound
        }

        purchasingProductID = productID

        // 2. 发起购买（使用 appAccountToken 绑定用户）
        let uuid = UUID(uuidString: userUUID) ?? UUID()
        let result = try await skProduct.purchase(options: [.appAccountToken(uuid)])

        purchasingProductID = nil

        switch result {
        case .userCancelled:
            // 刷新收据以便后续恢复使用
            try? await refreshReceipt()
            WHHHUD.whhHidenLoadView()
            throw WHHStoreKitError.purchaseFailed("用户取消购买")

        case .pending:
            try? await refreshReceipt()
            WHHHUD.whhHidenLoadView()
            throw WHHStoreKitError.purchaseFailed("购买待处理")

        case let .success(verification):
            // 3. 验证
            let transaction = try checkVerified(verification)
            // 4. 完成交易
            await transaction.finish()
            // 5. 确保收据存在（会自动刷新）
            try await ensureReceiptExists()
            // 6. 上传收据（带超时）
            try await uploadReceiptWithTimeout(orderId: orderId, timeout: uploadTimeout)
            // 上传成功后清理映射
            pendingOrderIdByProductId[productID] = nil
            return

            
        @unknown default:
            try? await refreshReceipt()
            throw WHHStoreKitError.purchaseFailed("未知购买状态")
        }
    }

    // MARK: - 交易更新监听

    /// 在 App 启动时调用，监听 Transaction.updates，校验并完成交易，必要时回补收据上传
    func startTransactionUpdatesListener() {
        // 避免重复启动
        if transactionUpdatesTask != nil { return }
        transactionUpdatesTask = Task.detached { [weak self] in
            guard let self else { return }
            for await update in Transaction.updates {
                do {
                    let transaction: Transaction = try self.checkVerified(update)
                    await transaction.finish()
                    try await self.ensureReceiptExists()
                    // 回补：若能找到下单时缓存的 orderId，则尝试上传收据
                    if let orderId = self.pendingOrderIdByProductId[transaction.productID] {
                        do {
                            try await self.uploadReceiptWithTimeout(orderId: orderId, timeout: self.uploadTimeout)
                            self.pendingOrderIdByProductId[transaction.productID] = nil
                        } catch {
                            // 上传失败留给前台流程重试
                        }
                    }
                } catch {
                    // 未验证通过，忽略该更新
                }
            }
        }
    }

    // MARK: - 验证交易签名

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw WHHStoreKitError.verificationFailed
        case let .verified(safe):
            return safe
        }
    }

    // MARK: - 收据相关

    /// 确保本地收据存在（若不存在或为空则刷新）
    func ensureReceiptExists() async throws {
        let url = Bundle.main.appStoreReceiptURL
        if url == nil || !FileManager.default.fileExists(atPath: url!.path) {
            try await refreshReceipt()
            return
        }
        let data = try Data(contentsOf: url!)
        if data.isEmpty {
            try await refreshReceipt()
        }
    }

    /// 强制刷新收据（调用 SKReceiptRefreshRequest）
    func refreshReceipt() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let req = SKReceiptRefreshRequest()
            // 强持有 delegate，直到收到回调后再移除
            let delegate = ReceiptRequestDelegate { [weak self] delegateInstance, success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "whh.receipt", code: -1, userInfo: [NSLocalizedDescriptionKey: "刷新收据失败"]))
                }
                // 回调后清理强引用
                if let self {
                    if let idx = self.activeReceiptDelegates.firstIndex(where: { $0 === delegateInstance }) {
                        self.activeReceiptDelegates.remove(at: idx)
                    }
                }
            }
            req.delegate = delegate
            // 注意：SKRequest.delegate 非强引用，需要手动保持生命周期
            self.activeReceiptDelegates.append(delegate)
            req.start()
        }
    }

    /// 从最新的 Bundle.main.appStoreReceiptURL 读取 base64 收据并上传（带超时包装）
    private func uploadReceiptWithTimeout(orderId: String, timeout: TimeInterval) async throws {
        // 重新确保收据
        try await ensureReceiptExists()

        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL),
              !receiptData.isEmpty else {
            WHHHUD.whhHidenLoadView()
            throw WHHStoreKitError.receiptEmpty
        }

        let base64 = receiptData.base64EncodedString()

        // 用 TaskGroup 实现超时：并发一个上传任务和一个 sleep 超时任务，先完成者为准
        try await withThrowingTaskGroup(of: Void.self) { group in
            // 上传任务
            group.addTask {
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                    // TODO: 替换为你真实的上传接口
                
                    FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(sandbox: self.isSandboxReceipt(), receiptData: base64,orderId: "") { success, msg in
                        WHHHUD.whhHidenLoadView()
                        if success == 1 {
                            continuation.resume()
                        } else {
                            continuation.resume(throwing: WHHStoreKitError.uploadFailed(msg))
                        }
                    }
                }
            }

            // 超时任务
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1000000000))
                WHHHUD.whhHidenLoadView()
                throw WHHStoreKitError.uploadTimeout
            }

            // 等待第一个完成
            try await group.next()!
            group.cancelAll()
        }
    }
    private func isSandboxReceipt() -> Bool {
        guard let url = Bundle.main.appStoreReceiptURL else { return false }
        return url.lastPathComponent == "sandboxReceipt"
    }
}

// MARK: - SKReceiptRefreshRequest delegate wrapper

private class ReceiptRequestDelegate: NSObject, SKRequestDelegate {
    private let completion: (ReceiptRequestDelegate, Bool, Error?) -> Void
    init(_ completion: @escaping (ReceiptRequestDelegate, Bool, Error?) -> Void) {
        self.completion = completion
    }

    func requestDidFinish(_ request: SKRequest) {
        completion(self, true, nil)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        completion(self, false, error)
    }
}
