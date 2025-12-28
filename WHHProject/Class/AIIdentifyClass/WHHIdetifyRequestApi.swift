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

    case likingLikeList

    case worksDelete

    case worksShare

    case worksDetail
    
    case myWorksList
    
    case likingLike
    
    case worksList
    
    
    case likingCancelLike
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
        case .likingLikeList:
            return "/liking/like/list"
        case .worksDelete:
            return "/works/delete"
        case .worksShare:
            return "/works/share"
        case .worksDetail:
            return "/works/detail"
        case .myWorksList:
            return "/my/works/list"
        case .likingLike:
            return "/liking/like"
        case .likingCancelLike:
            return "/liking/cancel-like"
        case .worksList:
            
            return "/works/list"
        }
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        switch aType {
        case .worksWaitList, .likingLikeList, .worksDetail,.myWorksList,.worksList:
            return .GET
        default:
            return .POST
        }
    }
}
