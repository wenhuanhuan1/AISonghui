//
//  FCVIPRequestApi.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/5.
//

import UIKit

enum WHHVIPRequestApiType: Int {
    /// 获取商品信息
    case payGoodsList
    /// 创建订单
    case payCreate
    ///  校验支付订单是否成功
    case payCheckResult
    /// 获取苹果已订阅的商品-1.0

    case payAppleSubscriptionGoods
}

class WHHVIPRequestApi: WHHRequest {
    private(set) var aParameters: [String: Any]?

    private(set) var aType: WHHVIPRequestApiType = .payGoodsList

    init(parameter: [String: Any] = [String: Any](), type: WHHVIPRequestApiType = .payGoodsList) {
        super.init()
        aType = type
        aParameters = parameter
    }

    override func requestUrl() -> String {
        switch aType {
        case .payGoodsList:
            return "pay/goods/list"
        case .payCreate:
            return "pay/create"
        case .payCheckResult:
            return "pay/check-result"
        case .payAppleSubscriptionGoods:
            return "pay/apple/subscription/goods"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        switch aType {
        case .payGoodsList,.payAppleSubscriptionGoods:
            return .GET
        default:
            return .POST
        }
    }
}
