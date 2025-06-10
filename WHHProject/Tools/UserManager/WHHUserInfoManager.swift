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

class WHHUserInfoManager: NSObject {
    static let shared = WHHUserInfoManager()

    /// 用户登录信息
    var userModel: WHHUserModel? {
        let userString = MMKV.default()?.string(forKey: WHHUserInfoManagerSaveUserInfoKey)
        let dict = userString?.mj_JSONObject
        let model = WHHUserModel.mj_object(withKeyValues: dict)
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
}
