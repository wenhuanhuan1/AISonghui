//
//  WHHUserInfoManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Foundation
import MJExtension
import MMKV
import UIKit
private let WHHUserInfoManagerSaveUserInfoKey = "WHHUserInfoManagerSaveUserInfoKey"

@objcMembers
class WHHUserInfoManager: NSObject {
    static let shared = WHHUserInfoManager()

    var confModel: WHHSystemModel {
        var model = WHHSystemModel()
        if let userString = MMKV.default()?.string(forKey: "whhSaveSystemConf") {
            let dict = userString.mj_JSONObject()
            model = WHHSystemModel.mj_object(withKeyValues: dict)
        }
        return model
    }

    var token: String {
        return userModel.token
    }

    var userId: String {
        return userModel.userId
    }

    var isShowpPrivacyAlert: Bool {
        if let show = MMKV.default()?.bool(forKey: "whhSaveShowPrivacyAlertView") {
            return show
        }
        return false
    }

    var isLogin: Bool {
        return !token.isEmpty
    }

    /// 用户登录信息
    var userModel: WHHUserModel {
        var model = WHHUserModel()
        if let userString = MMKV.default()?.string(forKey: WHHUserInfoManagerSaveUserInfoKey) {
            let dict = userString.mj_JSONObject()
            model = WHHUserModel.mj_object(withKeyValues: dict)
        }
        return model
    }

    /// 保存配置信息
    /// - Parameter conf: json
    static func whhSaveSystemConf(conf: String) {
        MMKV.default()?.set(conf, forKey: "whhSaveSystemConf")
        MMKV.default()?.sync()
    }
}

extension WHHUserInfoManager {
    static func initMMKV() {
        MMKV.initialize(rootDir: nil)
    }

    static func clearAllData() {
        MMKV.default()?.clearAll()
    }

    /// 保存用户登录信息
    /// - Parameter jsonString: 用户的json内容
    static func whhSaveUserInfoJsonString(jsonString: String) {
        MMKV.default()?.set(jsonString, forKey: WHHUserInfoManagerSaveUserInfoKey)
        MMKV.default()?.sync()
    }

    static func whhSaveShowPrivacyAlertView() {
        MMKV.default()?.set(true, forKey: "whhSaveShowPrivacyAlertView")
        MMKV.default()?.sync()
    }
}
