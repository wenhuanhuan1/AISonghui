//
//  WHHMineRequestApi.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

import UIKit

enum WHHMineRequestApiType: Int {
    case sysFeedback
    case sysFeedbackCheck
    case myLuckValueRecordList
}

class WHHMineRequestApi: WHHRequest {
    private(set) var aParameters: [String: Any]?

    private(set) var aType: WHHMineRequestApiType = .sysFeedback

    init(parameter: [String: Any] = [String: Any](), type: WHHMineRequestApiType = .sysFeedback) {
        super.init()
        aType = type
        aParameters = parameter
    }

    override func requestUrl() -> String {
        switch aType {
        case .sysFeedback:
            return "sys/feedback"
        case .sysFeedbackCheck:
            return "sys/feedback-check"
        case .myLuckValueRecordList:
            return "/my/luck-value/record/list"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        if aType == .sysFeedback {
            return .POST
        } else {
            return .GET
        }
    }
}
