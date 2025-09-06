//
//  WHHHomeRequestApi.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

import UIKit

enum WHHHomeRequestApiType: Int {
    case deviceInstall
    case loginMode1
    case witchList
    /// 注销账号
    case userDestroyApply
    /// 获取注销
    case getUserDestroyInfo
    /// 取消注销
    case userCancelDestroyApply
    /// 获取语言
    case appUserwitchGetFortune

    /// 订阅
    case appUserWitchSubscribe
    
    /// 获取我的信息
    case myDetail
    
    /// 提交信息
    
    case userUpdateInfo
    
    /// 获取预言
    
    case appUserWitchGetFortune
    
    /// 获取旧预言
    case appUserWitchGetOldFortune
    /// 获取系统配置信息
    
    /// 获取系统信息
    case sysInfo
}

class WHHHomeRequestApi: WHHRequest {
    private(set) var aParameters: [String: Any]?

    private(set) var aType: WHHHomeRequestApiType = .deviceInstall

    init(parameter: [String: Any] = [String: Any](), type: WHHHomeRequestApiType = .deviceInstall) {
        super.init()
        aType = type
        aParameters = parameter
    }

    override func requestUrl() -> String {
        switch aType {
        case .deviceInstall:
            return "/device/install"
        case .loginMode1:
            return "/login/mode/1"
        case .witchList:
            return "/witch/list"
        case .userDestroyApply:
            return "/user/destroy/apply"
        case .getUserDestroyInfo:
            return "/user/destroy/info"

        case .appUserwitchGetFortune:
            return "/app-user/witch/get-fortune"
        case .userCancelDestroyApply:
            return "/user/cancel/destroy/apply"
        case .appUserWitchSubscribe:
            return "/app-user/witch/subscribe"
        case .myDetail:
            return "/my/detail"
        case .userUpdateInfo:
            return "/user/update-info"
        case .appUserWitchGetFortune:
            return "/app-user/witch/get-fortune"
        case .appUserWitchGetOldFortune:
            return "/app-user/witch/get-old-fortune"
        case .sysInfo:
            return "/sys/info"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        switch aType {
        case .witchList, .appUserwitchGetFortune,.myDetail,.appUserWitchGetFortune,.appUserWitchGetOldFortune,.sysInfo:
            return .GET
        default:
            return .POST
        }
    }
}
