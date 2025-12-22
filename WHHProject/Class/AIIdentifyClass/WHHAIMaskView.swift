//
//  WHHAIMaskView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/22.
//

import UIKit

class WHHAIMaskView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colours: [Color0F0F12.withAlphaComponent(0),Color0F0F12], startPoint: CGPointMake(1, 0), endPoint: CGPointMake(1, 1))
    }

}
