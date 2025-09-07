//
//  WHHABBHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHABBHomeViewController: WHHBaseViewController {
    @IBOutlet var inputBgView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var textLabel: UILabel!

    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.setBackgroundImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return rightButton
    }()

    var model: WHHHomeWitchModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        inputBgView.layer.borderWidth = 1
        inputBgView.layer.borderColor = Color6C73FF.cgColor
        gk_navRightBarButtonItem = UIBarButtonItem(customView: rightButton)
        if let tempModel = model {
            iconImageView.whhSetImageView(url: tempModel.icon)
            textLabel.text = tempModel.meetingWords
        }
    }

    @IBAction func didInputeBarButtonClick(_ sender: UIButton) {
        let inputBarView = WHHABBInputBarView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        inputBarView.didInputeSendMsg = { msg in

            debugPrint("哈哈哈这是输入的内容\(msg)")
        }
        view.addSubview(inputBarView)
    }

    @objc func rightButtonClick() {
        let alertView = WHHABBSubscriptionAlertView()
        alertView.didSubscriptionSubmitButtonClickBlock = { [weak self] model, displayView in

            if model.subscribed == false {
                let subscriptAlertView = WHHDivinationAlertView()
                // 去订阅
                if WHHUserInfoManager.shared.userModel.vip == 1 {
                    subscriptAlertView.type = .subscription
                } else {
                    subscriptAlertView.type = .privilege
                }
                subscriptAlertView.smallTitleLabel.text = "是否订阅" + model.name + "女巫" + "「\(model.predictionName)」" + "，订阅后成功后，每天准点获取推送"
                subscriptAlertView.didCancleSubscriptionBlock = { [weak self] in
                    self?.whhSubscriptionRequest()
                    displayView.backButtonClick()
                }
                self?.view.addSubview(subscriptAlertView)
            }
        }
        alertView.model = model
        view.addSubview(alertView)
    }

    private func whhSubscriptionRequest() {
        guard let newSelectModel = model else { return }
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhSubscriptionRequest(witchId: newSelectModel.wichId) { [weak self] success, msg in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                if newSelectModel.subscribed {
                    newSelectModel.subscribed = false
                } else {
                    newSelectModel.subscribed = true
                }
                self?.model = newSelectModel
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }

            } else {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }
}
