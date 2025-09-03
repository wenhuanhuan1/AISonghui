//
//  WHHHomeRequestViewModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

import MJExtension
import UIKit
class WHHHomeRequestViewModel: NSObject {
    /// 设备安装或者第一次启动
    static func whhDeviceInstallRequest() {
        let api = WHHHomeRequestApi(parameter: ["api-v": "1.0", "model": WHHDeviceManager.whhGetDeviceModel(), "os": WHHDeviceManager.whhGetCurrentVersion(), "deviceId": WHHDeviceManager.whhGetIDFV()], type: .deviceInstall)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.code == 200 {
            } else {
                debugPrint("\(baseModel.msg)")
            }
        }
    }

    /// 登录
    /// - Parameter callHandle: 回调
    static func whhLoginRequest(callHandle: ((Bool) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["api-v": "1.0", "model": WHHDeviceManager.whhGetDeviceModel(), "os": WHHDeviceManager.whhGetCurrentVersion(), "deviceId": WHHDeviceManager.whhGetIDFV()], type: .loginMode1)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let json = (baseModel.data as AnyObject).mj_JSONString() {
                // 保存用户信息
                WHHUserInfoManager.whhSaveUserInfoJsonString(jsonString: json)
                callHandle?(true)
            } else {
                debugPrint("\(baseModel.msg)")
                callHandle?(false)
            }
        }
    }

    /// 获取女巫列表
    /// - Parameter callHandle: 回调
    static func whhHomeGetWitchList(callHandle: ((_ dataArray: [WHHHomeWitchModel]) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId], type: .witchList)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1,
               let array = WHHHomeWitchModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHHomeWitchModel]
            {
                callHandle?(array)
            } else {
                callHandle?([WHHHomeWitchModel]())
            }
        }
    }

    static func whhMineWriteOffAccoutRequest(callback: ((Int, WHHHomeWitchModel) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": "1.0", "reason": ""], type: .userDestroyApply)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeWitchModel.mj_object(withKeyValues: baseModel.data) {
                callback?(baseModel.success, model)
            } else {
                callback?(baseModel.success, WHHHomeWitchModel())
            }
        }
    }

    static func whhHomeGetPredictionRequest(callBlack: (() -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId], type: .appUserwitchGetFortune)

        api.whhStartConsequenceHandle { _ in

//            callback?(requestModel.success)
        }
    }

    /// 获取注销消息-1.0
    /// - Parameter callHandle: 回调
    static func whhMineGetUserDestroyInfo(callHandle: ((Int, WHHHomeWitchModel) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": "1.0"], type: .getUserDestroyInfo)
        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeWitchModel.mj_object(withKeyValues: baseModel.data) {
                callHandle?(baseModel.success, model)
            } else {
                callHandle?(baseModel.success, WHHHomeWitchModel())
            }
        }
    }

    static func whhMineCancleUserDestroyInfo(callHandle: ((Int) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": "1.0"], type: .userCancelDestroyApply)
        api.whhStartConsequenceHandle { baseModel in

            callHandle?(baseModel.success)
        }
    }

    static func whhSubscriptionRequest(witchId: String, callHandle: ((Int) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "witchId": witchId], type: .appUserWitchSubscribe)
        api.whhStartConsequenceHandle { baseModel in
            callHandle?(baseModel.success)
        }
    }

    /// 获取个人信息数据
    static func whhPersonGetMineUserInfoRequest(callBlack: ((Int, FCMineModel) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": "1.0"], type: .myDetail)
        api.whhStartConsequenceHandle { baseModel in
            if baseModel.success == 1, let model = FCMineModel.mj_object(withKeyValues: baseModel.data) {
                callBlack?(baseModel.success, model)
            } else {
                callBlack?(baseModel.success, FCMineModel())
            }
        }
    }

    /// 修改个人信息
    /// - Parameters:
    ///   - dict: 参数
    ///   - callBlack: 回调
    static func whhModificationPersonInfo(dict: [String: Any], callBlack: ((Int) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: dict, type: .userUpdateInfo)
        api.whhStartConsequenceHandle { baseModel in
            callBlack?(baseModel.code)
        }
    }

    static func whhUploadSourceWithType(type: Int, data: Data, callBlack: ((String) -> Void)?) {
        let uploadApi = FCUploadSourceApi(whhUploadWithType: Int32(type), sourceData: data)
        uploadApi.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let imageFile = baseModel.data as? String {
                callBlack?(imageFile)
            } else {
                callBlack?("")
            }
        }
    }
}
