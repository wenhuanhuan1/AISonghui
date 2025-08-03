//
//  WHHApplePayManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit
import StoreKit


enum WHHApplePayManagerReturn {
    /// 支付成功
    case finish
    /// 支付失败
    case fail
    /// 不支持
    case nonsupport
    /// 已经购买过
    case purchase

    case cancle
}

typealias WHHApplePayToolsResult = (_ error: WHHApplePayManagerReturn?) -> Void

class WHHApplePayManager: NSObject {

    var finishReceiptUrl: URL? {
        return Bundle.main.appStoreReceiptURL
    }
    // 是否可以支付
    private var isCanMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
   
    private(set) var productsRequest: SKProductsRequest?

    private(set) var paymentQueue: SKPaymentQueue?

    private(set) var payOrderId: String?

    private(set) var productId: String?
    static let shared = WHHApplePayManager()
    
    var payToolsResult: WHHApplePayToolsResult?
    
    override init() {
        super.init()
        paymentQueue = SKPaymentQueue.default()
        paymentQueue?.add(self)
    }
    
    
    /// 创建订单
    /// - Parameters:
    ///   - dict: 参数
    ///   - callBlack: 回调
    func whhCreateAppleBuyOrder(dict: [String: Any],callBlack:(WHHApplePayToolsResult)->Void?)  {
        
//        TimeMeetPayTools.timeMeetRequestSubmitOrder(parameters: dict) { [weak self] isFinish, model in
//
//            if isFinish {
//                if let newModel = model {
//                    self?.payOrderId = newModel.order_id
//                    self?.productId = newModel.product_id
//                    self?.whhRequetAppleOrder(productIdentifiers: newModel.product_id, orderId: newModel.order_id)
//
//                    self?.payToolsResult = { finish in
//                        buyCallbak?(finish!)
//                    }
//                } else {
//                    buyCallbak?(.fail)
//                }
//
//            } else {
//                buyCallbak?(.fail)
//            }
//        }
    }
    
    
    private func whhRequetAppleOrder(productIdentifiers: String, orderId: String) {
        
        if isCanMakePayments {
            productId = productIdentifiers
            payOrderId = orderId
            productsRequest = SKProductsRequest(productIdentifiers: Set(arrayLiteral: productIdentifiers))
            productsRequest?.delegate = self
            productsRequest?.start()

        } else {
            debugPrint("当前设备不支持支付")
            WHHApplePayManager.shared.payToolsResult?(.fail)
        }
    }
    
    deinit {
        paymentQueue?.remove(self)
    }

    private func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// 和后台效验
    private func checkAppPayBill(transaction: SKPaymentTransaction) {
        effectApplePlay(transation: transaction)
    }
    
    /// 和后台效验商品信息
    private func effectApplePlay(transation: SKPaymentTransaction) {
        debugPrint(transation)

        if let receiptUrl = finishReceiptUrl {
            do {
                let data = try Data(contentsOf: receiptUrl)

                let receiptBase64String = data.base64EncodedString()

                let transaction_id = transation.transactionIdentifier

                let order_id = payOrderId

                let dict = ["receipt": receiptBase64String, "order_id": order_id, "transaction_id": transaction_id]

//                TimeMeetPayTools.timeMeetRequestCheckOrder(parameters: dict as [String: Any]) { [weak self] isFinish, message in
//                    if isFinish {
//                        self?.payToolsResult?(.finish)
//                        dispatchAfter(deadline: 0.5) {
//                            HUD.showInfo(text: "支付成功")
//                        }
//                    } else {
//                        self?.payToolsResult?(.fail)
//                        dispatchAfter(deadline: 0.5) {
//                            HUD.showInfo(text: message)
//                        }
//                    }
//                }

            } catch {
                debugPrint("解析失败")
            }
        }
    }

    // 支付完成回调
    private func finishCallBack() {
        WHHApplePayManager.shared.payToolsResult?(.finish)
    }
}

extension WHHApplePayManager: SKPaymentTransactionObserver, SKProductsRequestDelegate{
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        WHHHUD.whhShowLoadView()
        let products = response.products
        for product in products {
            print("Product ID: \(product.productIdentifier), Price: \(product.price)")
        }

        if products.isEmpty {
            WHHHUD.whhHidenLoadView()
            debugPrint("没有该商品信息")
            dispatchAfter(delay: 0.5) {
                WHHHUD.whhShowInfoText(text: "没有找到该商品信息")
            }
           
            WHHApplePayManager.shared.payToolsResult?(.fail)
            return
        }

        if let firstProduct = products.first {
            purchaseProduct(product: firstProduct)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)

//                if var saveArray: [String] = TimeMeetKeychain.wzloadKeyString(TimeMeetApplePayToolsKey) as? [String] {
//                    saveArray.append(payOrderId ?? "")
//                    TimeMeetKeychain.wzSaveKeyString(TimeMeetApplePayToolsKey, saveData: saveArray)
//                } else {
//                    var newArray = [String]()
//
//                    newArray.append(payOrderId ?? "")
//                    TimeMeetKeychain.wzSaveKeyString(TimeMeetApplePayToolsKey, saveData: newArray)
//                }

                checkAppPayBill(transaction: transaction)
                break
            case .failed:
                WHHHUD.whhHidenLoadView()
                queue.finishTransaction(transaction)
                WHHApplePayManager.shared.payToolsResult?(.fail)
                break
            case .restored:
                WHHHUD.whhHidenLoadView()
                queue.finishTransaction(transaction)
                WHHApplePayManager.shared.payToolsResult?(.purchase)
                // Callback for restored purchase
                break
            case .deferred:
                WHHHUD.whhHidenLoadView()
                break
            case .purchasing:

                break
            @unknown default:
                break
            }
        }
    }
    
    
    
    func requestDidFinish(_ request: SKRequest) {
        debugPrint("发起请求成功\(request)")
//        HUD.hide()
    }

    func request(_ request: SKRequest, didFailWithError error: any Error) {
        debugPrint("发起请求失败\(error)")
//        HUD.hide()
    }
}
