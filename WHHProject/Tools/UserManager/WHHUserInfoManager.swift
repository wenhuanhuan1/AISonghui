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
