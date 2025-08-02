//
//  WHHlogoutAccoutViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit

class WHHlogoutAccoutViewController: WHHBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
    }

    @IBAction func backButtonCliick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func submitButtonClick(_ sender: UIButton) {
        debugPrint("点击了提交")
        let alertView = WHHlogoutAccoutAlertView()
        alertView.type = .logouting
        view.addSubview(alertView)
    }
}
