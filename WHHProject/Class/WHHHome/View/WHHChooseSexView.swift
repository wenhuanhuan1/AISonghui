//
//  WHHChooseSexView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/28.
//

import UIKit

class WHHChooseSexView: WHHBaseView {
    // 1男2女
    var didWHHChooseSexView: ((Int) -> Void)?

    lazy var bottomView: WHHBaseView = {
        let bottomView = WHHBaseView()
        bottomView.backgroundColor = .white
        return bottomView
    }()

    lazy var centernlineView: UIView = {
        let centernlineView = UIView()
        return centernlineView
    }()

    lazy var maleItemView: WHHSexItemView = {
        let maleItemView = WHHSexItemView()
        maleItemView.isSelect = true
        maleItemView.sexIcon.image = UIImage(named: "whhSetMaleIcon")
        maleItemView.backgroundColor = Color0091F
        maleItemView.didSelectButtonBlock = { [weak self] currentView in
            currentView.isSelect = true
            currentView.backgroundColor = Color0091F
            currentView.sexIcon.image = UIImage(named: "whhSetMaleIcon")

            self?.femaleItemView.isSelect = false
            self?.femaleItemView.sexIcon.image = UIImage(named: "whhSetFemaleIcon")
            self?.femaleItemView.backgroundColor = ColorF2F4FE
        }
        return maleItemView
    }()

    lazy var femaleItemView: WHHSexItemView = {
        let femaleItemView = WHHSexItemView()
        femaleItemView.titleLabel.text = "whhSetFemaleMaleTitleKey".localized
        femaleItemView.backgroundColor = ColorF2F4FE
        femaleItemView.sexIcon.image = UIImage(named: "whhSetFemaleIcon")
        femaleItemView.didSelectButtonBlock = { [weak self] currentView in

            currentView.isSelect = true
            currentView.sexIcon.image = UIImage(named: "whhFemaleWhiteIcon")
            currentView.backgroundColor = ColorFF4D94

            self?.maleItemView.isSelect = false
            self?.maleItemView.sexIcon.image = UIImage(named: "whhBlueMaleIcon")
            self?.maleItemView.backgroundColor = ColorF2F4FE
        }
        return femaleItemView
    }()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("whhConfirm".localized, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        submitButton.setTitleColor(.white, for: .normal)
        return submitButton
    }()

    lazy var titleLabel: WHHLabel = {
        let titleLabel = WHHLabel()
        titleLabel.whhSetLabel(textContent: "whhSetChooseAlertViewTitleKey".localized, color: Color353535, numberLine: 0, textFont: pingfangSemibold(size: 16)!, textContentAlignment: .center)
        return titleLabel
    }()

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = ColorE7E7E7
        return lineView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomView.whhAddSetRectConrner(corner: [.topLeft, .topRight], radile: 24)
    }

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.6)

        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(298 + WHHBottomSafe)
        }
        bottomView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(47)
        }
        bottomView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalTo(lineView.snp.top).offset(-11)
        }
        bottomView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(33)
            make.right.equalToSuperview().offset(-33)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 30)
        }

        bottomView.addSubview(centernlineView)
        centernlineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        bottomView.addSubview(maleItemView)
        bottomView.addSubview(femaleItemView)
        maleItemView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.size.equalTo(100)
            make.right.equalTo(bottomView.snp.centerX).offset(-20)
        }
        femaleItemView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(30)
            make.size.equalTo(100)
            make.left.equalTo(bottomView.snp.centerX).offset(20)
        }
    }

    @objc func submitButtonClick() {
        var tempSex = 0
        if maleItemView.isSelect {
            tempSex = 1
        } else if femaleItemView.isSelect {
            tempSex = 2
        }
        didWHHChooseSexView?(tempSex)
        removeFromSuperview()
    }
}
