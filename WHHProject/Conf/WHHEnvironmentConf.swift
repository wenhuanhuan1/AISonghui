//
//  WHHEnvironmentConf.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit

private let isDevelop = false

class WHHEnvironmentConf: NSObject {
    class var baseUrl: String {
        return isDevelop ? "" : ""
    }
}
