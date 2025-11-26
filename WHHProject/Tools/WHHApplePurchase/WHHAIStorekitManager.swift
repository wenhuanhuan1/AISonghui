//
//  WHHAIStorekitManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/25.
//

import Foundation
import StoreKit
import UIKit

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

        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId,
                                                                  payPage: payPage) { [weak self] model, code, msg in
            guard let self else { return }

            if code != 1 {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) { WHHHUD.whhShowInfoText(text: msg) }
                callBack?(false, msg)
                return
            }

            Task {
                await self.purchaseProduct(goodsCode: model.goodsCode,
                                           uuidString: model.uuid,
                                           orderId: model.orderId,
                                           callback: callBack)
            }
        }
    }

    // MARK: - 发起购买

    private func purchaseProduct(goodsCode: String,
                                 uuidString: String,
                                 orderId: String,
                                 callback: ((Bool, String) -> Void)?) async {
        do {
            guard let product = try await Product.products(for: [goodsCode]).first else {
                WHHHUD.whhHidenLoadView()
                callback?(false, "请求商品失败")
                return
            }

            await _purchaseAsync(product: product,
                                 uuidString: uuidString,
                                 orderId: orderId,
                                 callback: callback)
        } catch {
            WHHHUD.whhHidenLoadView()
            callback?(false, "请求商品失败")
        }
    }

    // MARK: - 实际购买处理（首次购买只弹一次密码）

    private func _purchaseAsync(product: Product,
                                uuidString: String,
                                orderId: String,
                                callback: ((Bool, String) -> Void)?) async {
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

                // 上传 transaction 给服务器验证
                await verifyTransactionWithServer(transaction, orderId: orderId, callback: callback)

            case .userCancelled:
                WHHHUD.whhHidenLoadView()
                callback?(false, "用户取消支付")

            case .pending:
                WHHHUD.whhHidenLoadView()
                callback?(false, "等待支付中")

            @unknown default:
                WHHHUD.whhHidenLoadView()
                callback?(false, "未知错误")
            }
        } catch {
            WHHHUD.whhHidenLoadView()
            debugPrint("当前开始报错了\(error.localizedDescription)")
            callback?(false, error.localizedDescription)
        }
    }

    // MARK: - 本地验证苹果签名

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T where T: TransactionLike {
        switch result {
        case let .unverified(_, error):
            throw error
        case let .verified(payload):
            return payload
        }
    }

    // MARK: - 上传 Transaction 给服务器验证

    private func verifyTransactionWithServer(_ transaction: Transaction,
                                             orderId: String,
                                             callback: ((Bool, String) -> Void)?) async {
        let isSandbox: Bool
        if #available(iOS 16.0, *) {
            isSandbox = (transaction.environment == .sandbox)
        } else {
            isSandbox = isSandboxReceipt()
        }

        await withCheckedContinuation { continuation in

            FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(sandbox: isSandbox, appAccountToken: transaction.appAccountToken?.uuidString ?? "", orderId: orderId, transactionId: String(transaction.id)) { success, msg, model in
                WHHHUD.whhHidenLoadView()

                if success == 1 {
                    if model.hasPlay == 1 {
                        callback?(true, model.prompt)
                    } else {
                        callback?(false, model.prompt)
                    }

                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: model.prompt)
                    }
                    Task { await transaction.finish() }
                } else {
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }

                    callback?(false, msg)
                }

                continuation.resume()
            }
        }
    }

    // MARK: - 恢复购买

    public func restorePurchase(callback: ((Bool, String) -> Void)?) {
        Task {
            var restored: [Transaction] = []

            for await result in Transaction.currentEntitlements {
                if case let .verified(transaction) = result {
                    restored.append(transaction)
                }
            }

            if restored.isEmpty {
                callback?(false, "没有可恢复的购买")
                return
            }

            // 逐个验证交易
            for transaction in restored {
                await verifyTransactionWithServer(transaction, orderId: "", callback: callback)
            }
        }
    }

    func jsonString(from dictionary: [String: Any]) -> String? {
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            print("字典无法转换为 JSON")
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        } catch {
            print("转换 JSON 失败: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - 判断本地 receipt 是否沙盒（老方法）

    private func isSandboxReceipt() -> Bool {
        guard let url = Bundle.main.appStoreReceiptURL else { return false }
        return url.lastPathComponent == "sandboxReceipt"
    }
}

// MARK: - TransactionLike 协议

@available(iOS 15.0, macOS 12.0, *)
private protocol TransactionLike {
    var id: UInt64 { get }
    var originalID: UInt64 { get }
    var productID: String { get }
    var appAccountToken: UUID? { get }
    func finish() async
}

@available(iOS 15.0, macOS 12.0, *)
extension Transaction: TransactionLike {}
