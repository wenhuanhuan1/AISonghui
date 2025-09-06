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
}
