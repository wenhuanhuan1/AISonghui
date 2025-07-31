//
//  WHHGradientButton.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colours: [Color67A9FF,Color6D64FF], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
    }

}
