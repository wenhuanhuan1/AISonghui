//
//  WHHAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

class WHHAlertView: WHHBaseView {
    lazy var centerContentView: UIView = {
        let centerContentView = UIView()
        centerContentView.layer.cornerRadius = 12
        centerContentView.layer.masksToBounds = true
        centerContentView.backgroundColor = .white
        return centerContentView
    }()

    lazy var cancleButton: UIButton = {
        let cancleButton = UIButton(type: .custom)
        cancleButton.setTitle("whhNetAlertContentRetryTitle".localized, for: .normal)
        cancleButton.layer.cornerRadius = 22
        cancleButton.layer.masksToBounds = true
        cancleButton.setTitleColor(Color66666, for: .normal)
        cancleButton.backgroundColor = ColorECEBF1
        cancleButton.titleLabel?.font = pingfangRegular(size: 14)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        return cancleButton
    }()

    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.setTitle("whhNetAlertContentSettingTitle".localized, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.backgroundColor = Color524059
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.whhSetLabel(textContent: "whhNetAlertBigTitle".localized, color: .black, numberLine: 1, textFont: pingfangSemibold(size: 16)!, textContentAlignment: .center)
        return titleLabel
    }()

    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.whhSetLabel(textContent: "whhNetAlertContentTitle".localized, color: .black, numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .center)
        return contentLabel
    }()

    var didSubmitBlock: ((WHHAlertView) -> Void)?

    override func setupViews() {
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.withAlphaComponent(0.5)
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

    static func initWHHAlertView(title: String, contentText: String, cancleTitle: String, submitTitle: String, callBlock: ((WHHAlertView) -> Void)?) {
        let view = WHHAlertView()
        UIWindow.getKeyWindow?.addSubview(view)
        view.titleLabel.text = title
        view.contentLabel.text = contentText
        view.cancleButton.setTitle(cancleTitle, for: .normal)
        view.submitButton.setTitle(submitTitle, for: .normal)
        view.didSubmitBlock = { currentView in
            callBlock?(currentView)
        }
    }

    @objc func cancleButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
        didSubmitBlock?(self)
    }
}
