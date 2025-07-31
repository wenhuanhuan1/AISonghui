//
//  WHHHomeItemView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/25.
//

import UIKit

class WHHHomeItemView: WHHBaseView {

    
    var didWHHHomeItemViewSubmitButton:(()->Void)?
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = pingfangMedium(size: 12)
        submitButton.layer.cornerRadius = 15
        submitButton.layer.masksToBounds = true
        return submitButton
    }()
    
    lazy var witchName: UILabel = {
        let witchName = UILabel()
        witchName.font = pingfangRegular(size: 14)
        witchName.textColor = Color746CF7
        witchName.numberOfLines = 0
        witchName.textAlignment = .center
        return witchName
    }()
    
    lazy var bigIconImageView: WHHBaseImageView = {
        let bigIconImageView = WHHBaseImageView()
        return bigIconImageView
    }()
    
    lazy var witchIconImageView: WHHBaseImageView = {
        let witchIconImageView = WHHBaseImageView()
        return witchIconImageView
    }()
    
    lazy var firstIcon: WHHBaseImageView = {
        let firstIcon = WHHBaseImageView()
        return firstIcon
    }()
    
    lazy var firstName: UILabel = {
        let firstName = UILabel()
        firstName.text = "奇门、八字"
        firstName.font = pingfangRegular(size: 10)
        firstName.textColor = Color2C2B2D
        firstName.numberOfLines = 0
        return firstName
    }()
    
    lazy var firstSmallLabel: UILabel = {
        let firstSmallLabel = UILabel()
        firstSmallLabel.text = "擅长"
        firstSmallLabel.font = pingfangMedium(size: 8)
        firstSmallLabel.textColor = Color6A6A6B
        firstSmallLabel.numberOfLines = 0
        return firstSmallLabel
    }()
    
    lazy var secondIcon: WHHBaseImageView = {
        let secondIcon = WHHBaseImageView()
        return secondIcon
    }()
    
    lazy var secondName: UILabel = {
        let secondName = UILabel()
        secondName.text = "奇门、八字"
        secondName.font = pingfangRegular(size: 10)
        secondName.textColor = Color2C2B2D
        secondName.numberOfLines = 0
        return secondName
    }()
    
    lazy var secondSmallLabel: UILabel = {
        let secondSmallLabel = UILabel()
        secondSmallLabel.text = "擅长"
        secondSmallLabel.font = pingfangMedium(size: 8)
        secondSmallLabel.textColor = Color6A6A6B
        secondSmallLabel.numberOfLines = 0
        return secondSmallLabel
    }()
    
    
    
    lazy var spellbookLabel: UILabel = {
        let spellbookLabel = UILabel()
        spellbookLabel.text = "巫语录："
        spellbookLabel.font = pingfangMedium(size: 8)
        spellbookLabel.textColor = Color6A6A6B
        spellbookLabel.numberOfLines = 0
        return spellbookLabel
    }()
    lazy var spellbookContentLabel: UILabel = {
        let spellbookContentLabel = UILabel()
        spellbookContentLabel.text = "奇门八字，可算你三生因果..."
        spellbookContentLabel.font = pingfangRegular(size: 10)
        spellbookContentLabel.textColor = Color2C2B2D
        spellbookContentLabel.numberOfLines = 0
        return spellbookContentLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = ColorDDE5F2
        return lineView
    }()
    
    lazy var subscriptionLabel: UILabel = {
        let subscriptionLabel = UILabel()
        subscriptionLabel.text = "订阅：1234人"
        subscriptionLabel.font = pingfangRegular(size: 8)
        subscriptionLabel.textColor = Color2C2B2D.whhAlpha(alpha: 0.52)
        subscriptionLabel.numberOfLines = 0
        subscriptionLabel.textAlignment = .center
        return subscriptionLabel
    }()
    
    
    
    lazy var divinationLabel: UILabel = {
        let divinationLabel = UILabel()
        divinationLabel.text = "占卜：1234人"
        divinationLabel.font = pingfangRegular(size: 8)
        divinationLabel.textColor = Color2C2B2D.whhAlpha(alpha: 0.52)
        divinationLabel.numberOfLines = 0
        divinationLabel.textAlignment = .center
        return divinationLabel
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(228)
            make.bottom.equalToSuperview().offset(-54)
        }
        
        addSubview(witchIconImageView)
        witchIconImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(103)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        addSubview(witchName)
        witchName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(81)
        }
        addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(86)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalTo(bigIconImageView.snp.bottom).offset(10)
        }
        bigIconImageView.addSubview(firstIcon)
        firstIcon.snp.makeConstraints { make in
            make.size.equalTo(23)
            make.left.equalToSuperview().offset(13)
            make.top.equalTo(witchName.snp.bottom).offset(12)
        }
        bigIconImageView.addSubview(firstName)
        firstName.snp.makeConstraints { make in
            make.left.equalTo(firstIcon.snp.right).offset(2)
            make.top.equalTo(firstIcon.snp.top).offset(-2)
            make.right.equalToSuperview().offset(-8)
        }
        bigIconImageView.addSubview(firstSmallLabel)
        firstSmallLabel.snp.makeConstraints { make in
            make.left.equalTo(firstIcon.snp.right).offset(2)
            make.top.equalTo(firstName.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(-8)
        }
        bigIconImageView.addSubview(secondIcon)
        secondIcon.snp.makeConstraints { make in
            make.size.equalTo(23)
            make.left.equalToSuperview().offset(13)
            make.top.equalTo(firstIcon.snp.bottom).offset(10)
        }
        bigIconImageView.addSubview(secondName)
        secondName.snp.makeConstraints { make in
            make.left.equalTo(secondIcon.snp.right).offset(2)
            make.top.equalTo(secondIcon.snp.top).offset(-2)
            make.right.equalToSuperview().offset(-8)
        }
        bigIconImageView.addSubview(secondSmallLabel)
        secondSmallLabel.snp.makeConstraints { make in
            make.left.equalTo(secondIcon.snp.right).offset(2)
            make.top.equalTo(secondName.snp.bottom).offset(0)
            make.right.equalToSuperview().offset(-8)
        }
        bigIconImageView.addSubview(spellbookLabel)
        spellbookLabel.snp.makeConstraints { make in
            make.left.equalTo(secondIcon)
            make.top.equalTo(secondIcon.snp.bottom).offset(13)
        }
        bigIconImageView.addSubview(spellbookContentLabel)
        spellbookContentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(spellbookLabel.snp.bottom).offset(0)
        }
        bigIconImageView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(spellbookContentLabel.snp.bottom).offset(6)
        }
        bigIconImageView.addSubview(subscriptionLabel)
        subscriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(lineView.snp.bottom).offset(6)
        }
        bigIconImageView.addSubview(divinationLabel)
        divinationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(subscriptionLabel.snp.bottom).offset(1)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
    @objc func submitButtonClick() {
        
        didWHHHomeItemViewSubmitButton?()
    }
}
