//
//  WHHBaseImageView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Kingfisher
import UIKit
class WHHBaseImageView: UIImageView {
    var cornerRadius: CGFloat = 0

    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    func whhSetImageView(url: String) {
        kf.setImage(with: URL(string: url), placeholder: whhPlaceholderIamge)
    }
}
