//
//  WHHAIIdentifyHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHAIIdentifyHomeViewController: WHHBaseViewController {

    lazy var bgIconImageView: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.image = UIImage(named: "whhHomwBgIcon")
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = true
        
        view.addSubview(bgIconImageView)
        bgIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
