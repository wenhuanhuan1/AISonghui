//
//  WHHAIWitchImageView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/4.
//

import UIKit

class WHHAIWitchImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientBackground(colors: [.white.withAlphaComponent(0),.white.withAlphaComponent(0.8)], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 1, y: 1))
    }
}
