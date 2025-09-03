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

    static func whhGetDeviceModel() -> String {
        var systemInfo = utsname()

        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1": return "iPhone 7"
        case"iPhone9,3": return "iPhone 7"
        case"iPhone9,2": return"iPhone 7 Plus"
        case"iPhone9,4": return"iPhone 7 Plus"
        case"iPhone10,1": return"iPhone 8"
        case"iPhone10,4": return"iPhone 8"
        case"iPhone10,2": return"iPhone 8 Plus"
        case"iPhone10,5": return"iPhone 8 Plus"
        case"iPhone10,3": return"iPhone X"
        case"iPhone10,6": return"iPhone X"
        case"iPhone11,8": return"iPhone XR"
        case"iPhone11,2": return"iPhone XS"
        case"iPhone11,6": return"iPhone XS Max"
        case"iPhone11,4": return"iPhone XS Max"
        case"iPhone12,1": return"iPhone 11"
        case"iPhone12,3": return"iPhone 11 Pro"
        case"iPhone12,5": return"iPhone 11 Pro Max"
        case"iPhone12,8": return"iPhone SE (2nd generation)"
        case"iPhone13,1": return"iPhone 12 mini"
        case"iPhone13,2": return"iPhone 12"
        case"iPhone13,3": return"iPhone 12 Pro"
        case"iPhone13,4": return"iPhone 12 Pro Max"
        case"iPhone14,4": return"iPhone 13 mini"
        case"iPhone14,5": return"iPhone 13"
        case"iPhone14,2": return"iPhone 13 Pro"
        case"iPhone14,3": return"iPhone 13 Pro Max"
        case"iPhone14,6": return"iPhone SE (3rd generation)"
        case"iPhone14,7": return"iPhone 14"
        case"iPhone14,8": return"iPhone 14 Plus"
        case"iPhone15,2": return"iPhone 14 Pro"
        case"iPhone15,3": return"iPhone 14 Pro Max"
        case"iPhone15,4": return"iPhone 15"
        case"iPhone15,5": return"iPhone 15 Plus"
        case"iPhone16,1": return"iPhone 15 Pro"
        case"iPhone16,2": return"iPhone 15 Pro Max"
        case"iPhone17,3": return"iPhone 16"
        case"iPhone17,4": return"iPhone 16 Plus"
        case"iPhone17,1": return"iPhone 16 Pro"
        case"iPhone17,2": return"iPhone 16 Pro Max"

        // iPad
        case"iPad1,1": return"iPad"
        case"iPad2,1": return"iPad 2"
        case"iPad2,2": return"iPad 2"
        case"iPad2,3": return"iPad 2"
        case"iPad2,4": return"iPad 2"
        case"iPad3,1": return"iPad (3rd generation)"
        case"iPad3,2": return"iPad (3rd generation)"
        case"iPad3,3": return"iPad (3rd generation)"
        case"iPad3,4": return"iPad (4th generation)"
        case"iPad3,5": return"iPad (4th generation)"
        case"iPad3,6": return"iPad (4th generation)"
        case"iPad6,11": return"iPad (5th generation)"
        case"iPad6,12": return"iPad (5th generation)"
        case"iPad7,5": return"iPad (6th generation)"
        case"iPad7,6": return"iPad (6th generation)"
        case"iPad7,11": return"iPad (7th generation)"
        case"iPad7,12": return"iPad (7th generation)"
        case"iPad11,6": return"iPad (8th generation)"
        case"iPad11,7": return"iPad (8th generation)"
        case"iPad12,1": return"iPad (9th generation)"
        case"iPad12,2": return"iPad (9th generation)"
        case"iPad4,1": return"iPad Air"
        case"iPad4,2": return"iPad Air"
        case"iPad4,3": return"iPad Air"
        case"iPad5,3": return"iPad Air 2"
        case"iPad5,4": return"iPad Air 2"
        case"iPad11,3": return"iPad Air (3rd generation)"
        case"iPad11,4": return"iPad Air (3rd generation)"
        case"iPad13,1": return"iPad Air (4th generation)"
        case"iPad13,2": return"iPad Air (4th generation)"
        case"iPad13,16": return"iPad Air (5th generation)"
        case"iPad13,17": return"iPad Air (5th generation)"
        case"iPad6,7": return"iPad Pro (12.9-inch)"
        case"iPad6,8": return"iPad Pro (12.9-inch)"
        case"iPad6,3": return"iPad Pro (9.7-inch)"
        case"iPad6,4": return"iPad Pro (9.7-inch)"
        case"iPad7,1": return"iPad Pro (12.9-inch) (2nd generation)"
        case"iPad7,2": return"iPad Pro (12.9-inch) (2nd generation)"
        case"iPad7,3": return"iPad Pro (10.5-inch)"
        case"iPad7,4": return"iPad Pro (10.5-inch)"
        case"iPad8,1": return"iPad Pro (11-inch)"
        case"iPad8,2": return"iPad Pro (11-inch)"
        case"iPad8,3": return"iPad Pro (11-inch)"
        case"iPad8,4": return"iPad Pro (11-inch)"
        case"iPad8,5": return"iPad Pro (12.9-inch) (3rd generation)"
        case"iPad8,6": return"iPad Pro (12.9-inch) (3rd generation)"
        case"iPad8,7": return"iPad Pro (12.9-inch) (3rd generation)"
        case"iPad8,8": return"iPad Pro (12.9-inch) (3rd generation)"
        case"iPad8,9": return"iPad Pro (11-inch) (2nd generation)"
        case"iPad8,10": return"iPad Pro (11-inch) (2nd generation)"
        case"iPad8,11": return"iPad Pro (12.9-inch) (4th generation)"
        case"iPad8,12": return"iPad Pro (12.9-inch) (4th generation)"
        case"iPad13,4": return"iPad Pro (11-inch) (3rd generation)"
        case"iPad13,5": return"iPad Pro (11-inch) (3rd generation)"
        case"iPad13,6": return"iPad Pro (11-inch) (3rd generation)"
        case"iPad13,7": return"iPad Pro (11-inch) (3rd generation)"
        case"iPad13,8": return"iPad Pro (12.9-inch) (5th generation)"
        case"iPad13,9": return"iPad Pro (12.9-inch) (5th generation)"
        case"iPad13,10": return"iPad Pro (12.9-inch) (5th generation)"
        case"iPad13,11": return "iPad Pro (12.9-inch) (5th generation)"
        case"iPad2,5": return"iPad mini"
        case"iPad2,6": return"iPad mini"
        case"iPad2,7": return"iPad mini"
        case"iPad4,4": return"iPad mini 2"
        case"iPad4,5": return"iPad mini 2"
        case"iPad4,6": return"iPad mini 2"
        case"iPad4,7": return"iPad mini 3"
        case"iPad4,8": return"iPad mini 3"
        case"iPad4,9": return"iPad mini 3"
        case"iPad5,1": return"iPad mini 4"
        case"iPad5,2": return"iPad mini 4"
        case"iPad11,1": return"iPad mini (5th generation)"
        case"iPad11,2": return"iPad mini (5th generation)"
        case"iPad14,1": return"iPad mini (6th generation)"
        case"iPad14,2": return"iPad mini (6th generation)"
        // 其他
        case"i386": return"iPhone Simulator"
        case"x86_64": return"iPhone Simulator"
        default: return identifier
        }
    }

    static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func whhGetIDFV() -> String {
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            return idfv
        }

        return ""
    }
}
