//
//  WHHAIStorekitManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/18.
//

import Foundation
import StoreKit

/// 简单的 StoreKit2 管理器（单例）
/// 功能：
/// - 列举产品
/// - 发起购买
/// - 监听交易更新
/// - 恢复/查询已购权益
/// - 本地校验 Transaction

@available(iOS 15.0, macOS 12.0, *)
public final class WHHAIStorekitManager: ObservableObject {
    public static let shared = WHHAIStorekitManager()

    @Published public private(set) var products: [Product] = []
    @Published public private(set) var purchasedIdentifiers: Set<String> = []
    @Published public private(set) var lastError: Error?

    private var updateTask: Task<Void, Never>?
    private init() {
        startTransactionListener()
    }

    deinit {
        updateTask?.cancel()
    }

    func createOrder(goodsId: String,
                     payPage: String = "VIP",
                     callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()

        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }

            if code == 1 {
                Task {
                    do {
                        guard let product = try await Product.products(for: [model.goodsCode]).first else {
                            WHHHUD.whhHidenLoadView()
                            callBack?(false, "请求商品失败")
                            return
                        }

                        self.purchase(product: product, uuidString: model.uuid) { success, msg in
                            callBack?(success, msg)
                        }

                    } catch {
                        WHHHUD.whhHidenLoadView()
                        callBack?(false, "请求商品失败")
                    }
                }

            } else {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) { WHHHUD.whhShowInfoText(text: msg) }
                callBack?(false, "请求失败")
            }
        }
    }

    // MARK: - Fetch products

    /// 传入 product IDs，返回已找到的 Product 列表
    public func fetchProducts(ids: [String]) async {
        do {
            let products = try await Product.products(for: ids)
            // 保持顺序：按 ids 的顺序排序
            let map = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
            self.products = ids.compactMap { map[$0] }
        } catch {
            lastError = error
            products = []
        }
    }

    private func isSandboxReceipt() -> Bool {
        guard let url = Bundle.main.appStoreReceiptURL else { return false }
        return url.lastPathComponent == "sandboxReceipt"
    }

    /// 将交易发送到自己服务器验证
    private func verifyWithServer(_ transaction: Transaction) async throws {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL),
              !receiptData.isEmpty else {
            WHHHUD.whhHidenLoadView()
            throw WHHStoreKitError.receiptEmpty
        }

        let base64 = receiptData.base64EncodedString()

        FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(sandbox: isSandboxReceipt(), receiptData: base64) { success, _ in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                debugPrint("验证成功")

            } else {
                debugPrint("验证失败")
            }
        }
    }

    /// 外部无需再写 Task，内部自动封装
    public func purchase(product: Product, uuidString: String, callback: @escaping (Bool, String) -> Void) {
        Task { [weak self] in
            await self?._purchaseAsync(product: product, uuidString: uuidString, callback: callback)
        }
    }

    /// 实际处理购买的异步方法
    private func _purchaseAsync(product: Product, uuidString: String, callback: @escaping (Bool, String) -> Void) async {
        do {
            let result = try await product.purchase(options: [.appAccountToken(UUID(uuidString: uuidString)!)])
            switch result {
               
            case let .success(verification):
                let transaction = try checkVerified(verification)
                try await verifyWithServer(transaction)
                await updatePurchasedIdentifiers()
                await transaction.finish()
                callback(true, transaction.productID)
            case .userCancelled:
                WHHHUD.whhHidenLoadView()
                callback(false, "用户取消支付")
            case .pending:
                WHHHUD.whhHidenLoadView()
                callback(false, "等待支付")
            @unknown default:
                WHHHUD.whhHidenLoadView()
                callback(false, "未知错误")
            }
        } catch {
            await MainActor.run { self.lastError = error }
            WHHHUD.whhHidenLoadView()
            callback(false, error.localizedDescription)
        }
    }

    // MARK: - Restore / Current entitlements

    /// 查询当前所有可用权益（包含订阅/非消耗）
    public func refreshEntitlements() async {
        await updatePurchasedIdentifiers()
    }

    /// 恢复购买（在 StoreKit2 中，可以通过读取 Transaction.currentEntitlements 来替代旧的 restorePurchases）
    public func restorePurchases() async {
        await updatePurchasedIdentifiers()
    }

    // MARK: - Transaction Listener

    // MARK: - Internal purchase async logic above

    private func startTransactionListener() {
        updateTask = Task.detached(priority: .background) { [weak self] in
            for await verificationResult in Transaction.updates {
                guard let self = self else { break }
                do {
                    let transaction = try self.checkVerified(verificationResult)
                    // 在这里根据 transaction.productID 做本地处理（解锁内容等）
                    await self.handle(transaction: transaction)
                    // 结束交易
                    await transaction.finish()
                } catch {
                    // 验证失败或其它错误
                    await MainActor.run {
                        self.lastError = error
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func handle(transaction: Transaction) async {
        // 将 product id/标识加入已购集合
        await MainActor.run {
            self.purchasedIdentifiers.insert(transaction.productID)
        }
        // 你可以在这里触发通知、更新服务器、解锁本地内容等
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T where T: TransactionLike {
        switch result {
        case let .unverified(_, verificationError):
            throw verificationError
        case let .verified(payload):
            return payload
        }
    }

    /// 更新本地 purchasedIdentifiers（读取当前 entitlements）
    private func updatePurchasedIdentifiers() async {
        var ids: Set<String> = []
        for await verificationResult in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(verificationResult)
                ids.insert(transaction.productID)
            } catch {
                await MainActor.run {
                    self.lastError = error
                }
            }
        }
        await MainActor.run {
            self.purchasedIdentifiers = ids
        }
    }
}

// MARK: - TransactionLike 协议：帮助泛型处理 VerificationResult

@available(iOS 15.0, macOS 12.0, *)
private protocol TransactionLike {
    var productID: String { get }
}

@available(iOS 15.0, macOS 12.0, *)
extension Transaction: TransactionLike {}
