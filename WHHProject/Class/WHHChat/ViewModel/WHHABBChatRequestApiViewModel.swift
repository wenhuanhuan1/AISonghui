//
//  WHHABBChatRequestApiViewModel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHABBChatRequestApiViewModel: NSObject {
    
    
    static var buffer = ""
    
    static func whhAbbChatSendMessageRequestApi(inputText: String,conversationId:String, callBlack: ((Int, String) -> Void)?) {
        
        let api = WHHABBChatRequestApi(parameter: ["input": inputText, "userId": WHHUserInfoManager.shared.userId,"conversationId":conversationId])
            .onChunk { chunk in
                
                buffer += chunk
                // 事件以双换行作为分隔
                let parts = buffer.components(separatedBy: "\n\n")
                buffer = parts.last ?? ""
                for i in 0..<(parts.count - 1) {
                    let eventText = parts[i]
                    let lines = eventText.components(separatedBy: .newlines)
                    let dataLines = lines.compactMap { line -> String? in
                        if line.hasPrefix("data:") {
                            var payload = String(line.dropFirst(5))
                            if payload.hasPrefix(" ") { payload.removeFirst() }
                            return payload
                        }
                        return nil
                    }
                    let message = dataLines.joined(separator: "\n")
                    // message 就是该事件合并后的完整文本
                    print("SSE message:", message)
                    
                    callBlack?(1,message)
                    
                }
            }
            .onComplete({
                buffer = ""
                debugPrint("数据流结束了")
                callBlack?(2,"结束")
            })
            .onError { error in
                buffer = ""
                debugPrint("数据流出现错误\(error)")
                callBlack?(0,"请求错误")
            }
        api.start()
    }
}
