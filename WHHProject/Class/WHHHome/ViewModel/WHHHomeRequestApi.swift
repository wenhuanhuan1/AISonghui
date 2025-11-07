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

    /// 修正预言
    case appUserWitchAmendFortune

    /// 首页首页banner配置-1.0

    case sysIndexBannerConfig
    /// 获取已订阅的女巫
    case appUserWitchSubscribeInfo

    /// 创建日报
    case appUserWitchCreateFortune

    /// 创建绘画

    case chatConversationCreate

    /// 会话列表

    case chatConversationList

    /// 聊天记录

    case chatMessage

    /// 删除会话

    case chatConversationDelete
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

        case .appUserWitchGetFortune:
            return "/app-user/witch/get-fortune"
        case .userCancelDestroyApply:
            return "/user/cancel/destroy/apply"
        case .appUserWitchSubscribe:
            return "/app-user/witch/subscribe"
        case .myDetail:
            return "/my/detail"
        case .userUpdateInfo:
            return "/user/update-info"

        case .appUserWitchGetOldFortune:
            return "/app-user/witch/get-old-fortune"
        case .sysInfo:
            return "/sys/info"
        case .appUserWitchAmendFortune:
            return "/app-user/witch/amend-fortune"
        case .sysIndexBannerConfig:
            return "/sys/index/banner/config"
        case .appUserWitchSubscribeInfo:
            return "/app-user/witch/subscribe/info"
        case .appUserWitchCreateFortune:
            return "/app-user/witch/create-fortune"

        case .chatConversationCreate:
            return "/chat/conversation/create"
        case .chatConversationList:
            return "/chat/conversation/list"
        case .chatMessage:
            return "/chat/message"
        case .chatConversationDelete:
            return "/chat/conversation/delete"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        switch aType {
        case .witchList, .appUserWitchGetFortune, .myDetail, .appUserWitchGetOldFortune, .sysInfo, .sysIndexBannerConfig, .appUserWitchSubscribeInfo, .appUserWitchCreateFortune, .chatConversationList, .chatMessage:
            return .GET
        case .chatConversationDelete:
            return .DELETE
        default:
            return .POST
        }
    }
}
