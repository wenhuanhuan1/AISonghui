//
//  WHHAIStorekitManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/18.
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
        }
        catch {
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
            // ⚠️ 支付前不刷新 receipt，避免重复密码弹窗
            let result = try await product.purchase(options: [.appAccountToken(uuid)])

            switch result {
            case let .success(verification):
                let transaction = try checkVerified(verification)

                debugPrint("Transaction ID: \(transaction.id)")
                debugPrint("Product ID: \(transaction.productID)")
                debugPrint("AppAccountToken: \(transaction.appAccountToken?.uuidString ?? "nil")")

                await transaction.finish()

                do {
                    try await self.verifyWithServer(transaction,
                                                    orderId: orderId,
                                                    callback: callback)
                } catch {
                    WHHHUD.whhHidenLoadView()
                    callback?(false, "服务器验证失败")
                }
                

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
            callback?(false, error.localizedDescription)
        }
    }

    // MARK: - 验证交易签名
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T where T: TransactionLike {
        switch result {
        case let .unverified(_, error):
            throw error
        case let .verified(payload):
            return payload
        }
    }

    // MARK: - 服务器验证（支付完成后刷新 receipt）
    private func verifyWithServer(_ transaction: Transaction,
                                  orderId: String,
                                  callback: ((Bool, String) -> Void)?) async throws {

        let receiptData = try await fetchLatestReceipt()
        let isSandbox = isSandboxReceipt()

        FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(
            sandbox: isSandbox,
            receiptData: receiptData,
            orderId: orderId
        ) { success, msg, model in

            WHHHUD.whhHidenLoadView()

            if success == 1 {
                if model.hasPlay == 1 {
                    callback?(true, model.prompt)
                } else {
                    callback?(false, model.prompt)
                }
            } else {
                callback?(false, msg)
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

            // 支付完成后刷新 receipt 上传服务器
            do {
                let latest = try await fetchLatestReceipt()
                let isSandbox = isSandboxReceipt()

                FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(
                    sandbox: isSandbox,
                    receiptData: latest,
                    orderId: ""
                ) { success, msg, model in
                    if success == 1, model.hasPlay == 1 {
                        callback?(true, "恢复购买成功")
                    } else {
                        callback?(false, msg)
                    }
                }
            } catch {
                callback?(false, "恢复失败：无法获取最新收据")
            }
        }
    }

    // MARK: - 获取最新 receiptData（Base64）
    private func fetchLatestReceipt() async throws -> String {
        if let b64 = readLocalReceipt(), !b64.isEmpty {
            return b64
        }

        try await AppStore.sync() // 支付完成或恢复购买时调用
        for _ in 0..<10 {
            try await Task.sleep(nanoseconds: 200_000_000)
            if let b64 = readLocalReceipt(), !b64.isEmpty {
                return b64
            }
        }

        return try await refreshReceiptUsingStoreKit1()
    }

    // MARK: - 读取本地 receipt
    private func readLocalReceipt() -> String? {
        guard let url = Bundle.main.appStoreReceiptURL,
              let data = try? Data(contentsOf: url),
              !data.isEmpty else { return nil }
        return data.base64EncodedString()
    }

    // MARK: - StoreKit1 兜底刷新 receipt
    private func refreshReceiptUsingStoreKit1() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let request = SKReceiptRefreshRequest()
            let delegate = ReceiptDelegate { success, error in
                if success, let b64 = self.readLocalReceipt(), !b64.isEmpty {
                    continuation.resume(returning: b64)
                } else {
                    continuation.resume(throwing: error ?? WHHStoreKitError.receiptEmpty)
                }
            }
            request.delegate = delegate
            request.start()
        }
    }

    // MARK: - 判断是否 Sandbox
    private func isSandboxReceipt() -> Bool {
        guard let url = Bundle.main.appStoreReceiptURL else { return false }
        return url.lastPathComponent == "sandboxReceipt"
    }
}

// MARK: - SKReceiptRefreshRequest 代理
private class ReceiptDelegate: NSObject, SKRequestDelegate {
    let handler: (Bool, Error?) -> Void

    init(handler: @escaping (Bool, Error?) -> Void) {
        self.handler = handler
    }

    func requestDidFinish(_ request: SKRequest) {
        handler(true, nil)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        handler(false, error)
    }
}

// MARK: - TransactionLike 协议
@available(iOS 15.0, macOS 12.0, *)
private protocol TransactionLike {
    var productID: String { get }
}

@available(iOS 15.0, macOS 12.0, *)
extension Transaction: TransactionLike {}
