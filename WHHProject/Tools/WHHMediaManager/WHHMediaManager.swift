//
//  WHHMediaManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit
import HXPhotoPicker_Lite
import Kingfisher
import Photos
import UIKit

class WHHMediaManager: NSObject {

    var whhCompletion: ((_ image: UIImage) -> Void)?
    static let shared = WHHMediaManager()
    func whhGetOnePhoto(viewController: UIViewController = UIViewController.currentViewController()!, comHandel: ((_ image: UIImage) -> Void)?) {
        var config = CameraConfiguration()
        config.isAutoBack = true
        config.tintColor = .black
        config.focusColor = ColorFF4746
        config.allowsEditing = false
        config.position = .front
        config.allowLocation = false
        config.indicatorType = .circle
        config.modalPresentationStyle = .overFullScreen
        let controller = CameraController(config: config, type: .photo, delegate: self)

        whhCompletion = { image in
            comHandel?(image)
        }
        viewController.present(controller, animated: false)
    }
}

extension WHHMediaManager: CameraControllerDelegate {
    func cameraController(_ cameraController: CameraController, didFinishWithResult result: CameraController.Result, phAsset: PHAsset?, location: CLLocation?) {
        cameraController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            switch result {
            case let .image(image):
                whhCompletion?(image)

            case let .video(videoURL):
                aism_camera(img: nil, url: videoURL)
            }
        }
    }

    func aism_camera(img: UIImage?, url: URL?) {
    }

    /// 权限申请
    static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited: // .limited 为 iOS 14+ 的受限权限
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }

   
}
