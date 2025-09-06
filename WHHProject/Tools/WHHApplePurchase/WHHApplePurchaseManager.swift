//
//  WHHApplePurchaseManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

import Foundation
import SwiftyStoreKit

enum WHHApplePurchaseResult {
    case success
    case fail
}

class WHHApplePurchaseManager: NSObject {
    static let shared = WHHApplePurchaseManager()
    var purchaseHandle: ((WHHApplePurchaseResult) -> Void)?

    override init() {
        super.init()
    }

    /// 创建订单
    /// - Parameters:
    ///   - goodsId: 商品信息
    ///   - payPage: 页面
    func whhCreateOrderRequest(goodsId: String, payPage: String) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyCreateOrderRequestApi(goodsId: goodsId, payPage: payPage) { [weak self] model, code, msg in
            if code == 1 {
                self?.whhInvocationSwiftyStoreKit(orderId: model.orderId, goodsId: model.productId)
            } else {
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        }
    }

    private func whhInvocationSwiftyStoreKit(orderId: String, goodsId: String) {
        SwiftyStoreKit.purchaseProduct(goodsId, atomically: false, applicationUsername: WHHUserInfoManager.shared.userId) { [self] result in
            switch result {
            case let .success(purchase):

                SwiftyStoreKit.fetchReceipt(forceRefresh: true) { [self] result in
                    switch result {
                    case let .success(receiptData):
                        let encryptedReceipt = receiptData.base64EncodedString()
                        WHHHUD.whhHidenLoadView()
                        whhInspectAndServer(transation: purchase.transaction, order: orderId, receiptData: encryptedReceipt)
                    case let .error(error):
                        debugPrint(error)
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        WHHHUD.whhHidenLoadView()
                        dispatchAfter(delay: 0.5) {
                            WHHHUD.whhShowInfoText(text: "购买失败")
                        }
                    }
                }
            case let .error(error):
                debugPrint(error)
                WHHHUD.whhHidenLoadView()
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: error.localizedDescription)
                }
            }
        }
    }

    private func whhInspectAndServer(transation: PaymentTransaction, order: String, receiptData: String) {
        WHHHUD.whhShowLoadView()
        FCVIPRequestApiViewModel.whhAppleBuyFinishAndServerCheck(orderId: order, receiptData: receiptData) { [weak self] success, msg in
            WHHHUD.whhHidenLoadView()
            SwiftyStoreKit.finishTransaction(transation)
            if success == 1 {
                self?.purchaseHandle?(.success)

            } else {
                self?.purchaseHandle?(.fail)
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        }
    }

    func whhRecoverAppleBuy() {
        WHHHUD.whhShowLoadView()
        SwiftyStoreKit.restorePurchases(atomically: false) { results in

            if results.restoredPurchases.count > 0 {
                // 遍历恢复的购买项进行验证调用恢复购买的接口
            } else if results.restoreFailedPurchases.count > 0 {
                WHHHUD.whhHidenLoadView()
                WHHHUD.whhShowInfoText(text: "恢复失败")
            } else {
                WHHHUD.whhHidenLoadView()
                WHHHUD.whhShowInfoText(text: "没有可恢复的购买项")
            }
        }
    }
}
