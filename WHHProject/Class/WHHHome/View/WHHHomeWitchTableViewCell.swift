//
//  WHHHomeWitchTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHHomeWitchTableViewCell: WHHBaseTableViewCell {
    lazy var buttomBgImageView: WHHBaseImageView = {
        let buttomBgImageView = WHHBaseImageView()
        buttomBgImageView.image = UIImage(named: "whhHomeButtomBgIcon")
        return buttomBgImageView
    }()

    lazy var centerItemView: WHHHomeItemView = {
        let centerItemView = WHHHomeItemView()
        centerItemView.bigIconImageView.image = UIImage(named: "whhHomeConstellationIcon")
        centerItemView.witchName.text = "神奇女巫"
        centerItemView.witchName.textColor = Color5A92FF
        centerItemView.witchIconImageView.image = UIImage(named: "whhHomeWonderWitchIcon")
        centerItemView.submitButton.setTitle("星座", for: .normal)
        centerItemView.submitButton.backgroundColor = Color5A92FF
        centerItemView.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage()
        }
        return centerItemView
    }()

    lazy var leftItemView: WHHHomeItemView = {
        let leftItemView = WHHHomeItemView()
        leftItemView.bigIconImageView.image = UIImage(named: "whhHomeHoroscopeIcon")
        leftItemView.witchName.text = "璇玑女巫"
        leftItemView.witchName.textColor = Color746CF7
        leftItemView.witchIconImageView.image = UIImage(named: "whhHomeWeiqiWitchIcon")
        leftItemView.submitButton.setTitle("奇门八字", for: .normal)
        leftItemView.submitButton.backgroundColor = Color746CF7
        leftItemView.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage()
        }
        return leftItemView
    }()

    lazy var rightItemView: WHHHomeItemView = {
        let rightItemView = WHHHomeItemView()
        rightItemView.bigIconImageView.image = UIImage(named: "whhHomeMagicIcon")
        rightItemView.witchName.text = "恶毒女巫"
        rightItemView.witchName.textColor = Color389E0D
        rightItemView.witchIconImageView.image = UIImage(named: "whhHomeVillainousWitchIcon")
        rightItemView.submitButton.setTitle("黑魔法", for: .normal)
        rightItemView.submitButton.backgroundColor = Color389E0D
        rightItemView.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage()
        }
        return rightItemView
    }()

    lazy var bottomTitle: UILabel = {
        let bottomTitle = UILabel()
        bottomTitle.text = "whhHomeBottomTitleKey".localized
        bottomTitle.font = pingfangSemibold(size: 14)
        bottomTitle.textColor = .white
        bottomTitle.layer.shadowColor = Color746CF7.cgColor
        bottomTitle.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomTitle.layer.shadowOpacity = 0.8

        bottomTitle.numberOfLines = 0
        bottomTitle.textAlignment = .center
        return bottomTitle
    }()

    lazy var bottomSmallTitle: UILabel = {
        let bottomSmallTitle = UILabel()
        bottomSmallTitle.text = "whhHomeBottomContentTitleKey".localized
        bottomSmallTitle.font = pingfangSemibold(size: 12)
        bottomSmallTitle.textColor = Color746CF7
        bottomSmallTitle.numberOfLines = 0
        bottomSmallTitle.textAlignment = .center
        return bottomSmallTitle
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setupViews() {
        super.setupViews()

        contentView.addSubview(buttomBgImageView)
        buttomBgImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo((WHHScreenW - 16) * 413 / 360)
        }
        buttomBgImageView.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(24)
        }
        buttomBgImageView.addSubview(bottomSmallTitle)
        bottomSmallTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(bottomTitle.snp.bottom).offset(9)
        }

        // 计算间距

        let padding = (WHHScreenW - (107 * 3)) / 4

        buttomBgImageView.addSubview(centerItemView)
        centerItemView.snp.makeConstraints { make in
            make.width.equalTo(107)
            make.height.equalTo(319)
            make.top.equalTo(bottomSmallTitle.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        buttomBgImageView.addSubview(leftItemView)
        leftItemView.snp.makeConstraints { make in
            make.size.bottom.equalTo(centerItemView)
            make.right.equalTo(centerItemView.snp.left).offset(-padding)
        }
        buttomBgImageView.addSubview(rightItemView)
        rightItemView.snp.makeConstraints { make in
            make.size.bottom.equalTo(centerItemView)
            make.left.equalTo(centerItemView.snp.right).offset(padding)
        }
    }

    private func didAbbHomePage() {
        if let currentVC = UIViewController.currentViewController() {
            let abbHomeVC = WHHABBHomeViewController()
            currentVC.navigationController?.pushViewController(abbHomeVC, animated: true)
        }
    }
}
