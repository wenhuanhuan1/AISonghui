//
//  WHHDeviceManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import Foundation

class WHHDeviceManager: NSObject {
    static func whhGetCurrentVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }

        return ""
    }
}
