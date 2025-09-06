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
