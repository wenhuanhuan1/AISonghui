//
//  WHHMineRequestApiViewModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

import UIKit

class WHHMineRequestApiViewModel: NSObject {
    /// 意见反馈接口
    static func whhMineSubmitFeedBack(content: String, imageData: Data, handle: ((Int, String) -> Void)?) {
        let api = WHHMineUploadApi(whhUploadWithType: 1, sourceData: imageData, content: content)
        api.whhStartConsequenceHandle { baseModel in
            handle?(baseModel.success, baseModel.msg)
        }
    }

    /// 检查是否已经提交过反馈
    /// - Parameter handle: 回调
    static func whhfeedbackCheck(handle: ((Int, String) -> Void)?) {
        let api = WHHMineRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv], type: .sysFeedbackCheck)
        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1,
               let model = WHHHomeWitchModel.mj_object(withKeyValues: baseModel.data) {
                handle?(model.exists, baseModel.msg)
            } else {
                handle?(0, baseModel.msg)
            }
        }
    }
    
    /// 我的命运丝线记录-1.0
    /// - Parameter handle: 回调
    static func whhGetMyLuckValueRecordList(lastGetMaxId:String,income:Int,handle: (([ WHHAIDestinyLineItemModel],Int, String) -> Void)?) {
        
        var dict = [String:Any]()
        if income == 0 {
            dict = ["userId": WHHUserInfoManager.shared.userId,"lastGetMaxId":lastGetMaxId, "api-v": WHHNetConf.apiv]
        }else if income == 1 {
            dict = ["userId": WHHUserInfoManager.shared.userId,"lastGetMaxId":lastGetMaxId, "api-v": WHHNetConf.apiv,"income":true]
        }else {
            dict = ["userId": WHHUserInfoManager.shared.userId,"lastGetMaxId":lastGetMaxId, "api-v": WHHNetConf.apiv,"income":false]
        }
        let api = WHHMineRequestApi(parameter: dict, type: .myLuckValueRecordList)
        api.whhStartConsequenceHandle { baseModel in

            if baseModel.success == 1,
               let model = WHHAIDestinyLineItemModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHAIDestinyLineItemModel] {
                handle?(model,baseModel.success, baseModel.msg)
            } else {
                handle?([WHHAIDestinyLineItemModel](),0, baseModel.msg)
            }
        }
    }
}
