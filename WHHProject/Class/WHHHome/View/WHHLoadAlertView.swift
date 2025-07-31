//
//  WHHLoadAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit

class WHHLoadAlertView: UIView {
    // MARK: - 初始化

    override init(frame: CGRect) {
        super.init(frame: frame)
   
        let nibName = UINib(nibName: "WHHLoadAlertView", bundle: nil)
        if let view = nibName.instantiate(withOwner: self, options: nil).first as? UIView {
            view.backgroundColor = .clear
            view.frame = frame
            addSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
