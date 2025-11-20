//
//  WHHABBChatRequestApiViewModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHABBChatRequestApiViewModel: NSObject {
    static func whhAbbChatSendMessageRequestApi(inputText: String,conversationId:String, callBlack: ((Int, String) -> Void)?) {
        
        let api = WHHABBChatRequestApi(parameter: ["input": inputText, "userId": WHHUserInfoManager.shared.userId,"conversationId":conversationId])
            .onChunk { chunk in
                debugPrint("\(chunk)")
                callBlack?(1,chunk)
            }
            .onComplete({
                debugPrint("数据流结束了")
                callBlack?(2,"结束")
            })
            .onError { error in
                debugPrint("数据流出现错误\(error)")
                callBlack?(0,"请求错误")
            }
        api.start()
    }
}
