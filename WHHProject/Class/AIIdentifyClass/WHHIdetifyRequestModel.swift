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
    class func whhPostRequestWorksMake(type:Int,prompt:String,speechFileId:String? = nil,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"type":type,"prompt":prompt,"speechFileId":speechFileId ?? "" ,"cnt":"1"], type: .worksMake)
       api.whhStartConsequenceHandle { baseModel in
           callBlackHandle?(baseModel.success,baseModel.msg)
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
    
    static func whhPostWorksDeleteRequest(worksId:String,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"worksId":worksId], type: .worksDelete)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1 {
                callBlackHandle?(1,baseModel.msg)
            }else{
                callBlackHandle?(0,baseModel.msg)
            }
            
        }
    }
    static func whhPostWorksShareRequest(worksId:String,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"worksId":worksId], type: .worksShare)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1 {
                callBlackHandle?(1,baseModel.msg)
            }else{
                callBlackHandle?(0,baseModel.msg)
            }
            
        }
    }
    
    static func whhGetWorksDetailRequest(worksId:String,callBlackHandle:((Int,WHHIntegralModel,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"worksId":worksId], type: .worksDetail)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let model = WHHIntegralModel.mj_object(withKeyValues: baseModel.data) {
                callBlackHandle?(1,model,baseModel.msg)
            }else{
                callBlackHandle?(0,WHHIntegralModel(),baseModel.msg)
            }
            
        }
    }
    static func whhGetMyWorksDetailRequest(worksId:String,callBlackHandle:((Int,WHHIntegralModel,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"worksId":worksId], type: .myWorksDetail)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let model = WHHIntegralModel.mj_object(withKeyValues: baseModel.data) {
                callBlackHandle?(1,model,baseModel.msg)
            }else{
                callBlackHandle?(0,WHHIntegralModel(),baseModel.msg)
            }
            
        }
    }
    
    static func whhGetMyShuoMengLikingLikeListRequest(lastGetMaxId:String,callBlackHandle:((Int,[WHHIntegralModel],String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"lastGetMaxId":lastGetMaxId,"size":"10"], type: .myWorksList)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let array = WHHIntegralModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHIntegralModel] {
                callBlackHandle?(1,array,baseModel.msg)
            }else{
                callBlackHandle?(0,[WHHIntegralModel](),baseModel.msg)
            }
            
        }
    }
    
    static func whhPostLikingLikeRequest(type:Int,contentId:String,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"type":type,"contentId":contentId], type: .likingLike)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1 {
                callBlackHandle?(1,baseModel.msg)
            }else{
                callBlackHandle?(0,baseModel.msg)
            }
            
        }
    }
    
    static func whhPostLikingCancelLikeRequest(type:Int,contentId:String,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"type":type,"contentId":contentId], type: .likingLike)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1 {
                callBlackHandle?(1,baseModel.msg)
            }else{
                callBlackHandle?(0,baseModel.msg)
            }
            
        }
    }
    
    static func whhGetWorksListRequest(page:Int,callBlackHandle:((Int,[WHHIntegralModel],String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"page":page,"size":"10"], type: .worksList)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1,let array = WHHIntegralModel.mj_objectArray(withKeyValuesArray: baseModel.data) as? [WHHIntegralModel] {
                callBlackHandle?(1,array,baseModel.msg)
            }else{
                callBlackHandle?(0,[WHHIntegralModel](),baseModel.msg)
            }
            
        }
    }
    
    static func whhPostWorksWaitListRemoveRequest(worksId:String,callBlackHandle:((Int,String)->Void)?) {
        
        let api = WHHIdetifyRequestApi(parameter: ["userId": WHHUserInfoManager.shared.userId, "api-v": WHHNetConf.apiv,"worksId":worksId], type: .worksWaitListRemove)
        api.whhStartConsequenceHandle { baseModel in
            
            if baseModel.success == 1 {
                callBlackHandle?(1,baseModel.msg)
            }else{
                callBlackHandle?(0,baseModel.msg)
            }
            
        }
    }
    
    class func whhAIMakeUploadAudio(data:Data,callBlack: ((String,String) -> Void)?) {
        
       let uploadApi = FCUploadSourceApi(whhUploadWithType: 5, sourceData: data)
       uploadApi.whhStartConsequenceHandle { baseModel in

           if baseModel.success == 1, let imageFile = baseModel.data as? String {
               callBlack?(imageFile,baseModel.msg)
           } else {
               callBlack?("",baseModel.msg)
           }
       }
        
    }
}
