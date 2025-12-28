//
//  WHHIdetifyRequestApi.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import UIKit

enum WHHIdetifyRequestApiType: Int {
   
    case worksMake
    
    case worksWaitList

}

class WHHIdetifyRequestApi: WHHRequest {

    private(set) var aParameters: [String: Any]?

    private(set) var aType: WHHIdetifyRequestApiType = .worksMake

    init(parameter: [String: Any] = [String: Any](), type: WHHIdetifyRequestApiType = .worksMake) {
        super.init()
        aType = type
        aParameters = parameter
    }

    override func requestUrl() -> String {
        switch aType {
        case .worksMake:
            return "/works/make"
        case .worksWaitList:
            return "/works/wait/list"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        switch aType {
        case .worksWaitList:
            return .GET
        default:
            return .POST
        }
    }
    
    
}
