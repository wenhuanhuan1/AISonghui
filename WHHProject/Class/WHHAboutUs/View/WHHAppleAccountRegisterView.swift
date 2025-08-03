//
//  WHHAppleAccountRegisterView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit

enum WHHAppleAccountRegisterViewType {
    case apple
    case logOut
}

class WHHAppleAccountRegisterView: UIView {
    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        return centerView
    }()

    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "Apple账号说明"
        bigTitle.textAlignment = .center
        bigTitle.font = pingfangSemibold(size: 16)
        bigTitle.textColor = Color2C2B2D
        return bigTitle
    }()

    lazy var bigContentTitle: UILabel = {
        let bigContentTitle = UILabel()
        bigContentTitle.text = "您当前正在以设备作为身份进行使用。"
        bigContentTitle.textAlignment = .center
        bigContentTitle.font = pingfangSemibold(size: 16)
        bigContentTitle.numberOfLines = 0
        bigContentTitle.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        return bigContentTitle
    }()

    lazy var smallTitle: UILabel = {
        let smallTitle = UILabel()
        smallTitle.text = "·绑定Apple账号后，当前设备数据会转移到Apple账号，设备身份会恢复至初始状态。"
        smallTitle.textAlignment = .left
        smallTitle.numberOfLines = 0
        smallTitle.font = pingfangRegular(size: 14)
        smallTitle.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        return smallTitle
    }()

//    lazy var smallTitle1: UILabel = {
//        let smallTitle1 = UILabel()
//        smallTitle1.text = "·Apple账号，可在后续更换新手机后，登录当前Apple账号，可继续使用当前账号的会员权限和所有记录。"
//        smallTitle1.textAlignment = .left
//        smallTitle1.numberOfLines = 0
//        smallTitle1.font = pingfangRegular(size: 14)
//        smallTitle1.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
//        return smallTitle1
//    }()
//    lazy var smallTitle2: UILabel = {
//        let smallTitle2 = UILabel()
//        smallTitle2.text = "·设备身份只支持当前手机使用，Apple账号可在任意登录手机使用。"
//        smallTitle2.textAlignment = .left
//        smallTitle2.numberOfLines = 0
//        smallTitle2.font = pingfangRegular(size: 14)
//        smallTitle2.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
//        return smallTitle2
//    }()
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

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("绑定Apple", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    init(type: WHHAppleAccountRegisterViewType) {
        super.init(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        setupViews()
        if type == .apple {
            bigTitle.text = "Apple账号已注册"
            bigContentTitle.text = "当前Apple账号已注册，你可以选择登录当前账号，使用此账号的会员权限与所有记录"
            submitButton.setTitle("登录", for: .normal)
        } else if type == .logOut {
            bigContentTitle.text = "退出当前Apple账号，使用设备身份进行访问，无法再继续使用Apple账号下的所有权限与记录"
            bigTitle.text = "退出登录"
            submitButton.setTitle("退出", for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .black.whhAlpha(alpha: 0.6)
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(225)
            make.center.equalToSuperview()
        }

        centerView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(32)
            make.height.equalTo(24)
        }
        centerView.addSubview(bigContentTitle)
        bigContentTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(bigTitle.snp.bottom).offset(8)
        }
        centerView.addSubview(backButton)
        centerView.addSubview(submitButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.width.height.bottom.equalTo(backButton)
        }
//        centerView.addSubview(smallTitle)
//        smallTitle.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(bigContentTitle.snp.bottom).offset(14)
//        }
//        centerView.addSubview(smallTitle1)
//        smallTitle1.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(smallTitle.snp.bottom).offset(12)
//        }
//        centerView.addSubview(smallTitle2)
//        smallTitle2.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(smallTitle1.snp.bottom).offset(12)
//        }
    }

    @objc func backButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
    }
}
