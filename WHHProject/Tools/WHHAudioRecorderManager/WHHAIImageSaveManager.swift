//
//  WHHAIImageSaveManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/29.
//

import Foundation

import UIKit
import Kingfisher
import Photos

final class WHHAIImageSaveManager {

    /// 使用 Kingfisher 下载图片并保存到相册
    static func saveImage(
        with urlString: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(false, NSError(domain: "InvalidURL", code: -1))
            return
        }

        // 请求相册权限
        requestPhotoPermission { granted in
            guard granted else {
                completion(false, NSError(domain: "PhotoPermissionDenied", code: -2))
                return
            }

            // 使用 Kingfisher 下载
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    saveToAlbum(image: value.image, completion: completion)

                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }

    // MARK: - 保存到相册
    private static func saveToAlbum(
        image: UIImage,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    // MARK: - 请求权限
    private static func requestPhotoPermission(
        completion: @escaping (Bool) -> Void
    ) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
        case .authorized, .limited:
            completion(true)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }

        default:
            completion(false)
        }
    }
}
