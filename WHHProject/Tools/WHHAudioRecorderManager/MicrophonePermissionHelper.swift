//
//  File.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import Foundation

import AVFoundation

final class MicrophonePermissionHelper {

    /// 判断并自动请求录音权限
    /// - Parameter completion: 最终是否获得权限
    static func checkAndRequest(_ completion: @escaping (Int) -> Void) {
        let session = AVAudioSession.sharedInstance()

        switch session.recordPermission {
        case .granted:
            // 已授权
            completion(1)

        case .denied:
            // 已拒绝
            completion(2)

        case .undetermined:
            // 未询问过，触发系统弹窗
            completion(0)

        @unknown default:
            completion(3)
        }
    }
}

extension MicrophonePermissionHelper{
    
    static func openSettings() {
           guard let url = URL(string: UIApplication.openSettingsURLString),
                 UIApplication.shared.canOpenURL(url) else { return }
           UIApplication.shared.open(url)
       }
}
