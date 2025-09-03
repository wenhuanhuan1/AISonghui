//
//  WHHDivinationAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

enum WHHDivinationAlertViewType {
    case subscription
    case cancleSubscription
    case privilege
}

class WHHDivinationAlertView: WHHBaseView {
    lazy var centerView: WHHBaseView = {
        let centerView = WHHBaseView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        return centerView
    }()
    
    var didCancleSubscriptionBlock:(()->Void)?

    lazy var privilegeButton: UIButton = {
        let privilegeButton = UIButton(type: .custom)
        privilegeButton.isHidden = true
        privilegeButton.setTitle("whhDivinationPrivilegeButtonTitleKey".localized, for: .normal)
        privilegeButton.setTitleColor(Color2C2B2D, for: .normal)
        privilegeButton.titleLabel?.font = pingfangRegular(size: 12)
        privilegeButton.addTarget(self, action: #selector(privilegeButtonClick), for: .touchUpInside)
        return privilegeButton
    }()

    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
        backButton.titleLabel?.font = pingfangRegular(size: 14)
        backButton.setTitleColor(Color2C2B2D, for: .normal)
        backButton.backgroundColor = ColorEDEBEF
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "取消订阅"
        titleLabel.font = pingfangSemibold(size: 16)
        titleLabel.textColor = Color2C2B2D
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
        submitButton.setImage(UIImage(named: "subscriptionManagerIcon"), for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var smallTitleLabel: UILabel = {
        let smallTitleLabel = UILabel()
        smallTitleLabel.text = "取消订阅后，你每天不会再收到女巫的专属占卜日报"
        smallTitleLabel.font = pingfangRegular(size: 16)
        smallTitleLabel.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        smallTitleLabel.numberOfLines = 0
        smallTitleLabel.textAlignment = .center
        return smallTitleLabel
    }()

    var type: WHHDivinationAlertViewType? {
        didSet {
            guard let tempType = type else { return }
            privilegeButton.isHidden = true
            if tempType == .subscription {
                titleLabel.text = "whhDivinationTitleKey".localized
                submitButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
                centerView.snp.updateConstraints { make in
                    make.height.equalTo(220)
                }
            } else if tempType == .cancleSubscription {
                titleLabel.text = "whhCancleDivinationTitleKey".localized
                submitButton.setTitle("whhCancleDivinationTitleKey".localized, for: .normal)
                centerView.snp.updateConstraints { make in
                    make.height.equalTo(201)
                }
            } else if tempType == .privilege {
                privilegeButton.isHidden = false
                titleLabel.text = "whhDivinationTitleKey".localized
                submitButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
                centerView.snp.updateConstraints { make in
                    make.height.equalTo(263)
                }
            }
        }
    }

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.6)
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.center.equalToSuperview()
            make.height.equalTo(263)
        }
        centerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
            make.height.equalTo(24)
        }
        centerView.addSubview(smallTitleLabel)
        smallTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-24)
        }
        centerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(44)
            make.top.equalTo(smallTitleLabel.snp.bottom).offset(20)
        }
        centerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.width.height.bottom.equalTo(backButton)
        }
        centerView.addSubview(privilegeButton)
        privilegeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc func backButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
        didCancleSubscriptionBlock?()
        backButtonClick()
    }

    @objc func privilegeButtonClick() {
        
    }
}
