//
//  WHHAIChatListDeleteView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

import UIKit

class WHHAIChatListDeleteView: WHHBaseView {
    var didSubmitButtonBlock: (() -> Void)?

    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        return centerView
    }()

    lazy var contDown: UIView = {
        let contDown = UIView()
        contDown.backgroundColor = ColorF2F4FE
        contDown.layer.cornerRadius = 12
        contDown.layer.masksToBounds = true
        return contDown
    }()

    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "确认注销"
        bigTitle.textAlignment = .center
        bigTitle.font = pingfangSemibold(size: 16)
        bigTitle.textColor = Color2C2B2D
        return bigTitle
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

    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.setTitle("注销", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = ColorFF4D4F
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var smallTitle: UILabel = {
        let smallTitle = UILabel()
        smallTitle.text = "点击【注销】，将会自动关闭APP并开始进行数据清理，清理时间预计需要24小时，24小时将无法正常访问。"
        smallTitle.textAlignment = .center
        smallTitle.numberOfLines = 0
        smallTitle.font = pingfangRegular(size: 16)
        smallTitle.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        return smallTitle
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.5)
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
        }
        centerView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(20)
        }
        centerView.addSubview(smallTitle)
        smallTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(bigTitle.snp.bottom).offset(8)
        }
        centerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(smallTitle.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        centerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.width.height.bottom.equalTo(backButton)
        }

    }

    @objc func backButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
        didSubmitButtonBlock?()
        backButtonClick()
    }
}
