//
//  WHHVIPCenterBgView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit

class WHHVIPCenterBgView: WHHBaseView {

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        applyGradient(colours: [Color5B5B8A.whhAlpha(alpha: 0.42),Color5B5B8A,Color5B5B8A])
    }
}
