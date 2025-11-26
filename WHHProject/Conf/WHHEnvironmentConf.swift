//
//  WHHEnvironmentConf.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit

private let isDevelop = true

@objcMembers
class WHHEnvironmentConf: NSObject {
    
    class var baseUrl: String {
        return isDevelop ? "https://testapi.abeibei.vip" : "https://api.abeibei.vip"
    }
}
