//
//  WHHDivinationViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHDivinationViewController: WHHBaseViewController {
    @IBOutlet var subscriptionButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var bottomView: UIImageView!
    @IBOutlet var ednvButton: UIButton!
    @IBOutlet var shenqiNvButton: UIButton!
    @IBOutlet var nvBgIocn: UIImageView!
    @IBOutlet var xuanjinvButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "whhDivinationNavTitleKey".localized
        gk_navBackgroundColor = .clear
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        ednvButton.layer.cornerRadius = 13
        ednvButton.layer.masksToBounds = true
        shenqiNvButton.layer.cornerRadius = 13
        shenqiNvButton.layer.masksToBounds = true
        xuanjinvButton.layer.cornerRadius = 13
        xuanjinvButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
        subscriptionButton.layer.cornerRadius = 22
        subscriptionButton.layer.masksToBounds = true
        subscriptionButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
        subscriptionButton.setTitle("whhDivinationFinishTitleKey".localized, for: .selected)
        subscriptionButton.setImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .normal)
        subscriptionButton.setImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .selected)
    }

    @IBAction func edNvButtonClick(_ sender: UIButton) {
        // 恶毒
    }

    @IBAction func shenqiNvButtonClick(_ sender: UIButton) {
        //神奇
    }

    @IBAction func xuanjiNVButtonClick(_ sender: UIButton) {
     // 玄机
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func subscriptionButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let subscriptAlertView = WHHDivinationAlertView()
        if sender.isSelected {
            subscriptAlertView.type = .privilege
        }else{
            subscriptAlertView.type = .subscription
        }
        
        view.addSubview(subscriptAlertView)
    }
}
