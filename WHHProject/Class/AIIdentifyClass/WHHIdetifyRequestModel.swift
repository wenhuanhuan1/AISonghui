//
//  WHHIdetifyRequestModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import UIKit

class WHHIdetifyRequestModel: NSObject {

    
    /// 制作-1.0
    /// - Parameters:
    ///   - type: 类型 1：图片 2：视频
    ///   - prompt:string提示词
    ///   - speechFileId: 语音文件ID
    ///   - callBlackHandle: 回调
   class func whhPostRequestWorksMake(type:Int,prompt:String,speechFileId:String? = nil,callBlackHandle:((String,String)->Void)?) {
        
       let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"type":type,"prompt":prompt,"speechFileId":speechFileId ?? "","cnt":"1","ratio":"16:9","resolution":"1664*936","demoImageFileId":""], type: .worksMake)
       api.whhStartConsequenceHandle { baseModel in
           callBlackHandle?(baseModel.code,baseModel.msg)
       }
    }
    
    class func whhGetRequestWorksWaitList(callBlackHandle:((Int,WHHIntegralModel,String)->Void)?) {
         
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv], type: .worksWaitList)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let model = WHHIntegralModel.mj_object(withKeyValues: baseModel.data) {
                callBlackHandle?(1,model,baseModel.msg)
            }else{
                callBlackHandle?(0,WHHIntegralModel(),baseModel.msg)
            }
            
        }
     }
    
    static func whhGetLikingLikeListRequest(page:Int,callBlackHandle:((Int,[WHHIntegralModel],String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"page":page,"size":"10"], type: .likingLikeList)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let array = WHHIntegralModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHIntegralModel] {
                callBlackHandle?(1,array,baseModel.msg)
            }else{
                callBlackHandle?(0,[WHHIntegralModel](),baseModel.msg)
            }
            
        }
    }
}
