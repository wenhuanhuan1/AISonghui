//
//  WHHHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

class WHHHomeViewController: WHHBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        dispatchAfter(delay: 1) {
            WHHAlertView.initWHHAlertView(title: "whhNetAlertBigTitle".localized, contentText: "whhNetAlertContentTitle".localized, cancleTitle: "whhNetAlertContentRetryTitle".localized, submitTitle: "whhNetAlertContentSettingTitle".localized) { showView in
                showView.cancleButtonClick()
            }
        }
    }
}
