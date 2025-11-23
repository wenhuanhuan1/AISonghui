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

    private init() {}

    // MARK: - 创建订单并购买
    public func createOrder(goodsId: String,
                            payPage: String = "VIP",
                            callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()

        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }

            if code != 1 {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) { WHHHUD.whhShowInfoText(text: msg) }
                callBack?(false, "请求失败")
                return
            }

            Task {
                await self.purchaseProduct(goodsCode: model.goodsCode, uuidString: model.uuid, orderId: model.orderId, callback: callBack)
            }
        }
    }

    // MARK: - 购买封装
    private func purchaseProduct(goodsCode: String, uuidString: String, orderId: String, callback: ((Bool, String) -> Void)?) async {
        do {
            guard let product = try await Product.products(for: [goodsCode]).first else {
                WHHHUD.whhHidenLoadView()
                callback?(false, "请求商品失败")
                return
            }

            await _purchaseAsync(product: product, uuidString: uuidString, orderId: orderId, callback: callback)
        } catch {
            WHHHUD.whhHidenLoadView()
            callback?(false, "请求商品失败")
        }
    }

    // MARK: - 实际购买处理
    private func _purchaseAsync(product: Product, uuidString: String, orderId: String, callback: ((Bool, String) -> Void)?) async {
        guard let uuid = UUID(uuidString: uuidString) else {
            WHHHUD.whhHidenLoadView()
            callback?(false, "UUID 格式错误")
            return
        }

        do {
            let result = try await product.purchase(options: [.appAccountToken(uuid)])

            switch result {
            case let .success(verification):
                let transaction = try checkVerified(verification)

                debugPrint("Transaction ID: \(transaction.id)")
                debugPrint("Product ID: \(transaction.productID)")
                debugPrint("AppAccountToken: \(transaction.appAccountToken?.uuidString ?? "nil")")

                // 异步服务器验证收据，不阻塞 UI
                Task.detached {
                    do {
                        try await self.verifyWithServer(transaction, orderId: orderId)
                    } catch {
                        debugPrint("服务器验证失败：\(error.localizedDescription)")
                    }
                }

                // 完成交易，让系统弹支付成功弹窗
                await transaction.finish()

                WHHHUD.whhHidenLoadView()
                callback?(true, transaction.productID)

            case .userCancelled:
                WHHHUD.whhHidenLoadView()
                callback?(false, "用户取消支付")

            case .pending:
                WHHHUD.whhHidenLoadView()
                callback?(false, "等待支付")

            @unknown default:
                WHHHUD.whhHidenLoadView()
                callback?(false, "未知错误")
            }

        } catch {
            await MainActor.run { self.lastError = error }
            WHHHUD.whhHidenLoadView()
            callback?(false, error.localizedDescription)
        }
    }

    // MARK: - 验证交易
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T where T: TransactionLike {
        switch result {
        case let .unverified(_, verificationError):
            throw verificationError
        case let .verified(payload):
            return payload
        }
    }

    // MARK: - 服务器验证
    private func verifyWithServer(_ transaction: Transaction, orderId: String) async throws {
        let base64Receipt = try await fetchLatestReceipt()
        let isSandbox = isSandboxReceipt()

        FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(
            sandbox: isSandbox,
            receiptData: base64Receipt,
            orderId: orderId
        ) { success, msg in
            if success == 1 {
                debugPrint("服务器验证成功")
            } else {
                debugPrint("服务器验证失败")
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    // MARK: - 收据相关
    private func fetchLatestReceipt() async throws -> String {
        if let b64 = readLocalReceipt(), !b64.isEmpty {
            return b64
        }
        try await AppStore.sync()
        if let b64 = readLocalReceipt(), !b64.isEmpty {
            return b64
        }
        throw WHHStoreKitError.receiptEmpty
    }

    private func readLocalReceipt() -> String? {
        guard let url = Bundle.main.appStoreReceiptURL,
              let data = try? Data(contentsOf: url),
              !data.isEmpty else { return nil }
        return data.base64EncodedString()
    }

    private func isSandboxReceipt() -> Bool {
        guard let url = Bundle.main.appStoreReceiptURL else { return false }
        return url.lastPathComponent == "sandboxReceipt"
    }
}

// MARK: - TransactionLike 协议
@available(iOS 15.0, macOS 12.0, *)
private protocol TransactionLike {
    var productID: String { get }
}

@available(iOS 15.0, macOS 12.0, *)
extension Transaction: TransactionLike {}
