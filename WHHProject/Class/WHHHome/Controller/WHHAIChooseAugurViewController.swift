//
//  WHHAIChooseAugurViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit

class WHHAIChooseAugurViewController: WHHBaseViewController {

    lazy var augurView: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .zhiming)
        view.didWHHAIAugurViewButtonBlock = {
            
            
        }
        return augurView
    }()
    
    lazy var augurView1: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .xuanji)
        view.didWHHAIAugurViewButtonBlock = {
            
            
        }
        return augurView1
    }()
    lazy var augurView2: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .siye)
        view.didWHHAIAugurViewButtonBlock = {
            
            
        }
        return augurView2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "选择占卜师"
        gk_navTitleColor = .black
        gk_backStyle = .black
        view.addSubview(augurView)
        augurView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 10)
        }
        view.addSubview(augurView1)
        augurView1.snp.makeConstraints { make in
            make.left.right.height.equalTo(augurView)
            make.top.equalTo(augurView.snp.bottom).offset(10)
        }
        view.addSubview(augurView2)
        augurView2.snp.makeConstraints { make in
            make.left.right.height.equalTo(augurView1)
            make.top.equalTo(augurView1.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
        }
        
    }
    
}
