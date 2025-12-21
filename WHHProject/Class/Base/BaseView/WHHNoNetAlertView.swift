//
//  WHHNoNetAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

class WHHNoNetAlertView: WHHBaseView {

    lazy var centerContentView: UIView = {
        let centerContentView = UIView()
        centerContentView.layer.cornerRadius = 12
        centerContentView.layer.masksToBounds = true
        centerContentView.backgroundColor = Color030303
        return centerContentView
    }()

    lazy var cancleButton: UIButton = {
        let cancleButton = UIButton(type: .custom)
        cancleButton.setTitle("退出", for: .normal)
        cancleButton.layer.cornerRadius = 22
        cancleButton.layer.masksToBounds = true
        cancleButton.layer.borderWidth = 1
        cancleButton.layer.borderColor = UIColor.white.cgColor
        cancleButton.setTitleColor(.white.withAlphaComponent(0.9), for: .normal)
        cancleButton.backgroundColor = Color2C2B2D
        cancleButton.titleLabel?.font = pingfangRegular(size: 14)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        return cancleButton
    }()

    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.setTitle("检查网络设置", for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.setTitleColor(Color2C2B2D, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.backgroundColor = .white
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.whhSetLabel(textContent: "无法连接到网络", color: .white, numberLine: 1, textFont: pingfangSemibold(size: 18)!, textContentAlignment: .center)
        return titleLabel
    }()

    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.whhSetLabel(textContent: "您的网络连接好像已经断开了请检测网络设置后重新尝试", color: .white.withAlphaComponent(0.5), numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .center)
        return contentLabel
    }()

    var didSubmitBlock: ((WHHNoNetAlertView) -> Void)?
    
    var againSubmitBlock: ((WHHNoNetAlertView) -> Void)?

    override func setupViews() {
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = Color0F0F12
        addSubview(centerContentView)
        centerContentView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
        centerContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        centerContentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        centerContentView.addSubview(cancleButton)
        cancleButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        centerContentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(cancleButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.width.height.bottom.equalTo(cancleButton)
        }
    }

    @objc func cancleButtonClick() {
        againSubmitBlock?(self)
    }

    @objc func submitButtonClick() {
        didSubmitBlock?(self)
    }

}
