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
        let api = WHHHomeRequestApi(parameter: ["api-v": WHHNetConf.apiv, "model": WHHDeviceManager.whhGetDeviceModel(), "os": WHHDeviceManager.whhGetCurrentVersion(), "deviceId": WHHDeviceManager.whhGetIDFV()], type: .deviceInstall)

        api.whhStartConsequenceHandle { _ in
        }
    }

    /// 登录
    /// - Parameter callHandle: 回调
    static func whhLoginRequest(callHandle: ((Bool,String) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["api-v": WHHNetConf.apiv, "model": WHHDeviceManager.whhGetDeviceModel(), "os": WHHDeviceManager.whhGetCurrentVersion(), "deviceId": WHHDeviceManager.whhGetIDFV()], type: .loginMode1)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let json = (baseModel.data as AnyObject).mj_JSONString() {
                // 保存用户信息
                WHHUserInfoManager.whhSaveUserInfoJsonString(jsonString: json)
                callHandle?(true,baseModel.msg)
            } else {
                debugPrint("\(baseModel.msg)")
                callHandle?(false,baseModel.msg)
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
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv, "reason": ""], type: .userDestroyApply)

        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeWitchModel.mj_object(withKeyValues: baseModel.data) {
                callback?(baseModel.success, model)
            } else {
                callback?(baseModel.success, WHHHomeWitchModel())
            }
        }
    }

    /// 获取注销消息-1.0
    /// - Parameter callHandle: 回调
    static func whhMineGetUserDestroyInfo(callHandle: ((Int, WHHHomeWitchModel) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv], type: .getUserDestroyInfo)
        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeWitchModel.mj_object(withKeyValues: baseModel.data) {
                callHandle?(baseModel.success, model)
            } else {
                callHandle?(baseModel.success, WHHHomeWitchModel())
            }
        }
    }

    static func whhMineCancleUserDestroyInfo(callHandle: ((Int, String) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv], type: .userCancelDestroyApply)
        api.whhStartConsequenceHandle { baseModel in

            callHandle?(baseModel.success, baseModel.msg)
        }
    }

    static func whhSubscriptionRequest(witchId: String, callHandle: ((Int, String) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "witchId": witchId], type: .appUserWitchSubscribe)
        api.whhStartConsequenceHandle { baseModel in
            callHandle?(baseModel.success, baseModel.msg)
        }
    }

    /// 获取个人信息数据
    static func whhPersonGetMineUserInfoRequest(callBlack: ((Int, FCMineModel) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv], type: .myDetail)
        api.whhStartConsequenceHandle { baseModel in
            if baseModel.success == 1, let model = FCMineModel.mj_object(withKeyValues: baseModel.data) {
                let oldModel = WHHUserInfoManager.shared.userModel
                oldModel.logo = model.logo
                oldModel.vip = model.vip
                oldModel.birthday = model.birthday

                if let jsonModel = oldModel.mj_JSONString() {
                    WHHUserInfoManager.whhSaveUserInfoJsonString(jsonString: jsonModel)
                }

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
            callBlack?(baseModel.success)
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

    /// 获取新预言
    static func whhHomeGetWHHHomeappUserWitchGetFortuneRequest(callBlack: ((Int, WHHHomeForetellModel, String) -> Void)?) {
        let requestApi = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId], type: .appUserWitchGetFortune)
        requestApi.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeForetellModel.mj_object(withKeyValues: baseModel.data) {
                callBlack?(baseModel.success, model, baseModel.msg)
            } else {
                callBlack?(baseModel.success, WHHHomeForetellModel(), baseModel.msg)
            }
        }
    }

    /// 获取旧预言
    static func whhHomeGetWHHHomeappUserWitchGetOldFortuneRequest(callBlack: ((Int, WHHHomeForetellModel, String) -> Void)?) {
        let requestApi = WHHHomeRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId], type: .appUserWitchGetOldFortune)
        requestApi.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHHomeForetellModel.mj_object(withKeyValues: baseModel.data) {
                callBlack?(baseModel.success, model, baseModel.msg)
            } else {
                callBlack?(baseModel.success, WHHHomeForetellModel(), baseModel.msg)
            }
        }
    }

    static func whhGetSystemInfoRequestApi(callBlack: ((Int) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["api-v": WHHNetConf.apiv, "userId": WHHUserInfoManager.shared.userId], type: .sysInfo)
        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1, let model = WHHSystemModel.mj_object(withKeyValues: baseModel.data), let jsonString = model.mj_JSONString() {
                WHHUserInfoManager.whhSaveSystemConf(conf: jsonString)
            }
            callBlack?(baseModel.success)
        }
    }

    /// 修正预言接口
    /// - Parameters:
    ///   - inputString: 输入的内容
    ///   - callBlack: 回调
    static func whhPOSTAppUserWitchAmendFortuneRequest(inputString: String, callBlack: ((Int, String) -> Void)?) {
        let api = WHHHomeRequestApi(parameter: ["input": inputString, "userId": WHHUserInfoManager.shared.userId], type: .appUserWitchAmendFortune)
        api.whhStartConsequenceHandle { baseModel in
            callBlack?(baseModel.success, baseModel.msg)
        }
    }
}
