//
//  WHHSexItemView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHSexItemView: WHHBaseView {
    var didSelectButtonBlock: ((_ currentView: WHHSexItemView) -> Void)?

    var isSelect:Bool = false
    
    lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: .custom)
        selectButton.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
        return selectButton
    }()

    lazy var sexIcon: UIImageView = {
        let sexIcon = UIImageView()
        sexIcon.image = UIImage(named: "whhBlueMaleIcon")
        return sexIcon
    }()

    lazy var titleLabel: WHHLabel = {
        let titleLabel = WHHLabel()
        titleLabel.whhSetLabel(textContent: "whhSetSexMaleTitleKey".localized, color: Color2C2B2D, numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .center)
        return titleLabel
    }()

    override func setupViews() {
        super.setupViews()
        backgroundColor = ColorF2F4FE
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(sexIcon)
        sexIcon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sexIcon.snp.bottom).offset(10)
        }
        addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func selectButtonClick() {
        didSelectButtonBlock?(self)
    }
}
