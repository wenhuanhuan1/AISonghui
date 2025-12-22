//
//  WHAIInputView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/22.
//

import UIKit

class WHHCustomMakeButton: WHHBaseView {
    var didButtonClickBlock: (() -> Void)?
    lazy var title: UILabel = {
        let a = UILabel()
        a.font = pingfangMedium(size: 14)
        return a
    }()

    lazy var icon: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.backgroundColor = .clear
        return a
    }()

    lazy var coutView: UIView = {
        let a = UIView()
        a.backgroundColor = .clear
        return a
    }()

    lazy var btn: UIButton = {
        let a = UIButton(type: .custom)
        a.addTarget(self, action: #selector(customButtonClick), for: .touchUpInside)
        return a
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(coutView)
        coutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        coutView.addSubview(title)
        coutView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.top.bottom.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(4)
            make.right.top.bottom.equalToSuperview()
        }
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func customButtonClick() {
        didButtonClickBlock?()
    }
}

class WHAIInputView: WHHBaseView {
    lazy var inputBgContenView: UIView = {
        let a = UIView()
        a.backgroundColor = .black
        return a
    }()

    private(set) var selectType = 0

    lazy var keyboardBtn: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "whhAIKeyBoardBtnIcon"), for: .normal)
        a.setImage(UIImage(named: "whhAIKeyBoardBtnIcon"), for: .selected)
        a.addTarget(self, action: #selector(keyboardButtonClick(btn:)), for: .touchUpInside)
        return a
    }()

    lazy var videoButton: WHHCustomMakeButton = {
        let a = WHHCustomMakeButton()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.title.text = "梦成视频"
        a.icon.image = UIImage(named: "whhAIMakeSelectVideoIcon")
        a.title.textColor = .white.withAlphaComponent(0.9)
        a.backgroundColor = .white.withAlphaComponent(0.1)
        a.didButtonClickBlock = { [weak self] in

            self?.videoButton.backgroundColor = .white.withAlphaComponent(0.1)
            self?.videoButton.title.textColor = .white.withAlphaComponent(0.9)
            self?.videoButton.icon.image = UIImage(named: "whhAIMakeSelectVideoIcon")

            self?.phoneButton.icon.image = UIImage(named: "whhAIMakeNormalPictureIcon")
            self?.phoneButton.title.textColor = .white.withAlphaComponent(0.5)
            self?.phoneButton.backgroundColor = .clear

            self?.selectType = 0
        }
        return a
    }()

    lazy var phoneButton: WHHCustomMakeButton = {
        let a = WHHCustomMakeButton()
        a.title.text = "梦成图片"
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.icon.image = UIImage(named: "whhAIMakeNormalPictureIcon")
        a.title.textColor = .white.withAlphaComponent(0.5)

        a.didButtonClickBlock = { [weak self] in

            self?.phoneButton.title.textColor = .white.withAlphaComponent(0.9)
            self?.phoneButton.icon.image = UIImage(named: "whhAIMakeSelectPictureIcon")
            self?.phoneButton.backgroundColor = .white.withAlphaComponent(0.1)

            self?.videoButton.icon.image = UIImage(named: "whhAIMakeNormalVideoIcon")
            self?.videoButton.title.textColor = .white.withAlphaComponent(0.5)
            self?.videoButton.backgroundColor = .clear

            self?.selectType = 1
        }

        return a
    }()

    lazy var inputTextViewBgView: WHHBaseView = {
        let a = WHHBaseView()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.backgroundColor = .white.withAlphaComponent(0.05)
        return a
    }()

    lazy var selectBgView: UIView = {
        let a = UIView()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.backgroundColor = .white.withAlphaComponent(0.05)
        return a
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = Color0F0F12.withAlphaComponent(0.6)
        addSubview(inputBgContenView)
        inputBgContenView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        inputBgContenView.addSubview(selectBgView)
        selectBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(48)
        }

        selectBgView.addSubview(videoButton)
        selectBgView.addSubview(phoneButton)
        videoButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        phoneButton.snp.makeConstraints { make in
            make.left.equalTo(videoButton.snp.right)
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(videoButton)
        }
        inputBgContenView.addSubview(inputTextViewBgView)
        inputTextViewBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(selectBgView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(44)
        }
        inputTextViewBgView.addSubview(keyboardBtn)
        keyboardBtn.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    @objc func keyboardButtonClick(btn: UIButton) {
    }
}
