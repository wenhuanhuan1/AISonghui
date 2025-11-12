//
//  WHHAIInAppPurchaseV2Manager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/12.
//

import StoreKit
import UIKit

class WHHAIInAppPurchaseV2Manager: NSObject {
    private var purchasingProductID: String?

    static let shared = WHHAIInAppPurchaseV2Manager()

    private(set) var purchaseProduct: Product?

    /// 创建订单
    /// - Parameters:
    ///   - productID: 商品
    ///   - userUUID: uuid
    ///   - callBack: 回调
    func inAppPurchaseV2ManagerCreateOrder(goodsId: String, payPage: String = "VIP", callBack: ((Bool, String) -> Void)?) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            if code == 1 {
                self?.inAppPurchaseV2ManagerStartPurchasing(productID: model.goodsCode, userUUID: model.uuid, orderId: model.orderId, callBack: { success, msg in
                    callBack?(success, msg)
                })

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
    /// - Parameters:
    ///   - productID: 商品id
    ///   - userUUID: 服务器返回的ID
    ///   - callBack: 回调
    private func inAppPurchaseV2ManagerStartPurchasing(productID: String, userUUID: String, orderId: String, callBack: ((Bool, String) -> Void)?) {
        Task {
            do {
                // 获取商品信息
                if let storeProducts = try? await Product.products(for: [productID]),
                   let purchaseProduct = storeProducts.first {
                    purchasingProductID = productID

                    // 发起购买
                    let result = try await purchaseProduct.purchase(
                        options: [.appAccountToken(UUID(uuidString: userUUID)!)]
                    )
                    purchasingProductID = nil

                    switch result {
                    case let .success(verification):
                        let transaction = try checkVerified(verification)
                        await transaction.finish()

                        Task {
                            // 上传收据给服务器
                            whhInspectAndServer(orderId: orderId) { success, msg in
                                callBack?(success, msg)
                            }
                        }

                    case .userCancelled:
                        WHHHUD.whhHidenLoadView()
                        callBack?(false, "用户取消购买")

                    case .pending:
                        WHHHUD.whhHidenLoadView()
                        callBack?(false, "购买待处理")

                    @unknown default:
                        WHHHUD.whhHidenLoadView()
                        callBack?(false, "未知购买状态")
                    }
                } else {
                    WHHHUD.whhHidenLoadView()
                    callBack?(false, "未找到商品")
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
            throw NSError(domain: "iap.verify.failed", code: -1, userInfo: [NSLocalizedDescriptionKey: "交易验证失败"])
        }
    }

    // MARK: - 恢复购买

    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                print("🔄 已恢复：\(transaction.productID)")
            } catch {
                print("❌ 恢复失败：\(error)")
            }
        }
    }

    // MARK: - 获取历史交易

    func fetchTransactionHistory() async {
        for await result in Transaction.all {
            do {
                let transaction = try checkVerified(result)
                print("🧾 历史交易：\(transaction.productID) at \(transaction.purchaseDate)")
            } catch {
                print("❌ 验证交易失败：\(error)")
            }
        }
    }

    private func whhInspectAndServer(orderId: String, callBlock: ((Bool, String) -> Void)?) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: appStoreReceiptURL) {
            let base64Receipt = receiptData.base64EncodedString()

            WHHHUD.whhShowLoadView()
            FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(orderId: orderId, receiptData: base64Receipt) { success, msg in
                WHHHUD.whhHidenLoadView()
                if success == 1 {
                    callBlock?(true, "支付成功")
                } else {
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }
                    callBlock?(false, "支付失败")
                }
            }

        } else {
            WHHHUD.whhHidenLoadView()
            callBlock?(false, "获取本地票据失败")
        }
    }
}
