//
//  FCVIPRequestApiViewModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/5.
//

import UIKit

class FCVIPRequestApiViewModel: NSObject {
    /// 获取商品信息列表
    /// - Parameter callback: 回调
    static func whhRequestProductList(callback: (([WHHVIPCenterModel]) -> Void)?) {
        let requestApi = WHHVIPRequestApi(parameter: ["groups": "1", "api-v": WHHNetConf.apiv, "userId": WHHUserInfoManager.shared.userId], type: .payGoodsList)
        requestApi.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let array = WHHVIPCenterModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHVIPCenterModel] {
                callback?(array)
            } else {
                callback?([WHHVIPCenterModel]())
            }
        }
    }
    
    /// 苹果支付创建订单
    /// - Parameters:
    ///   - goodsId: 商品id
    ///   - payPage: 页面
    ///   - sandbox: 是否沙盒默认沙盒
    ///   - callBlack: 回调
    static func whhAppleBuyCreateOrderRequestApi(goodsId: String, payPage: String, callBlack: ((WHHVIPCenterModel,Int,String) -> Void)?) {
        let requestApi = WHHVIPRequestApi(parameter: ["api-v": WHHNetConf.apiv, "userId": WHHUserInfoManager.shared.userId, "goodsId": goodsId, "payPage": payPage, "sandbox": WHHNetConf.isSandbox], type: .payCreate)

        requestApi.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHVIPCenterModel.mj_object(withKeyValues: baseModel.data) {
                callBlack?(model,baseModel.success,baseModel.msg)
            } else {
                callBlack?(WHHVIPCenterModel(),baseModel.success,baseModel.msg)
            }
        }
    }
    
    
    /// 苹果支付和我方服务器校验
    /// - Parameters:
    ///   - orderId: 订单号
    ///   - receiptData: 支付票据
    ///   - callBlack: 回调
    static func whhAppleBuyFinishAndServerCheck(orderId:String,receiptData:String,callBlack:((Int,String)->Void)?) {
    
        let requestApi = WHHVIPRequestApi(parameter: ["api-v": WHHNetConf.apiv, "userId": WHHUserInfoManager.shared.userId, "orderId": orderId, "receiptData": receiptData], type: .payCreate)

        requestApi.whhStartConsequenceHandle { baseModel in
            callBlack?(baseModel.success,baseModel.msg)
        }
    }
}
