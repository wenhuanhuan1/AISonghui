//
//  UIImageView+KF.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

import Foundation

extension UIImageView {
    func whhSetKFWithImage(imageString: String) {
        kf.setImage(with: URL(string: imageString))
    }
}
