//
//  WHHRootViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

class WHHRootViewController: WHHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if WHHUserInfoManager.shared.isShowpPrivacyAlert == false {
            let agenmetView = WHHAgreementView()
            view.addSubview(agenmetView)
        }
      
        // Do any additional setup after loading the view.
    }
    
}
