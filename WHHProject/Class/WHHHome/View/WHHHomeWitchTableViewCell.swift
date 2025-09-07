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
        let view = WHHHomeItemView()
        view.button.tag = 1
        view.bigIconImageView.image = UIImage(named: "whhHomeConstellationIcon")
        view.witchName.text = "神奇女巫"
        view.witchName.textColor = Color5A92FF
        view.witchIconImageView.image = UIImage(named: "whhHomeWonderWitchIcon")
        view.submitButton.setTitle("星座", for: .normal)
        view.submitButton.backgroundColor = Color5A92FF
        view.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage(btn: view.button)
        }
        return view
    }()

    lazy var leftItemView: WHHHomeItemView = {
        let view = WHHHomeItemView()
        view.button.tag = 0
        view.bigIconImageView.image = UIImage(named: "whhHomeHoroscopeIcon")
        view.witchName.text = "璇玑女巫"
        view.witchName.textColor = Color746CF7
        view.witchIconImageView.image = UIImage(named: "whhHomeWeiqiWitchIcon")
        view.submitButton.setTitle("奇门八字", for: .normal)
        view.submitButton.backgroundColor = Color746CF7
        view.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage(btn: view.button)
        }
        return view
    }()

    lazy var rightItemView: WHHHomeItemView = {
        let view = WHHHomeItemView()
        view.button.tag = 2
        view.bigIconImageView.image = UIImage(named: "whhHomeMagicIcon")
        view.witchName.text = "恶毒女巫"
        view.witchName.textColor = Color389E0D
        view.witchIconImageView.image = UIImage(named: "whhHomeVillainousWitchIcon")
        view.submitButton.setTitle("黑魔法", for: .normal)
        view.submitButton.backgroundColor = Color389E0D
        view.didWHHHomeItemViewSubmitButton = { [weak self] in
            self?.didAbbHomePage(btn: view.button)
        }
        return view
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

    private func didAbbHomePage(btn: UIButton) {
        if let tempArray = dataArray, btn.tag < tempArray.count {
            if let currentVC = UIViewController.currentViewController() {
                let model = tempArray[btn.tag]
                let abbHomeVC = WHHABBHomeViewController()
                abbHomeVC.model = model
                currentVC.navigationController?.pushViewController(abbHomeVC, animated: true)
            }
        }
    }

    var dataArray: [WHHHomeWitchModel]? {
        didSet {
            if let newDataArray = dataArray, newDataArray.isEmpty == false {
                let model1 = newDataArray[0]

                leftItemView.witchName.text = model1.name
                leftItemView.witchName.textColor = UIColor(hex: model1.luckyColorValue)
                leftItemView.submitButton.backgroundColor = UIColor(hex: model1.luckyColorValue)
                leftItemView.witchIconImageView.whhSetImageView(url: model1.icon)
                leftItemView.firstIcon.image = UIImage(named: "songuiBgIcon")
                leftItemView.secondIcon.image = UIImage(named: "SonghuimenghuanzhiIIcon")
                leftItemView.firstName.text = model1.goodAt
                leftItemView.secondName.text = model1.luckyColor
                leftItemView.spellbookContentLabel.text = model1.quotes
                leftItemView.subscriptionLabel.text = "订阅: \(model1.stat.subscribeTimes)人"
                leftItemView.divinationLabel.text = "占卜: \(model1.stat.fortuneTimes)次"

                let model2 = newDataArray[1]

                centerItemView.witchName.text = model2.name
                centerItemView.witchName.textColor = UIColor(hex: model2.luckyColorValue)
                centerItemView.submitButton.backgroundColor = UIColor(hex: model2.luckyColorValue)
                centerItemView.witchIconImageView.whhSetImageView(url: model2.icon)
                centerItemView.firstIcon.backgroundColor = UIColor(hex: model2.luckyColorValue)
                centerItemView.firstName.text = model2.goodAt
                centerItemView.secondName.text = model2.luckyColor
                centerItemView.spellbookContentLabel.text = model2.quotes
                centerItemView.subscriptionLabel.text = "订阅: \(model2.stat.subscribeTimes)人"
                centerItemView.divinationLabel.text = "占卜: \(model2.stat.fortuneTimes)次"

                centerItemView.firstIcon.image = UIImage(named: "SHxingzhuIcon")
                centerItemView.secondIcon.image = UIImage(named: "songghiColor1Icon")

                let model3 = newDataArray[2]

                rightItemView.witchName.text = model3.name
                rightItemView.witchName.textColor = UIColor(hex: model3.luckyColorValue)
                rightItemView.submitButton.backgroundColor = UIColor(hex: model3.luckyColorValue)
                rightItemView.witchIconImageView.whhSetImageView(url: model3.icon)
                rightItemView.firstIcon.backgroundColor = UIColor(hex: model3.luckyColorValue)
                rightItemView.firstName.text = model3.goodAt
                rightItemView.secondName.text = model3.luckyColor
                rightItemView.spellbookContentLabel.text = model3.quotes
                rightItemView.subscriptionLabel.text = "订阅: \(model3.stat.subscribeTimes)人"
                rightItemView.divinationLabel.text = "占卜: \(model3.stat.fortuneTimes)次"
                rightItemView.firstIcon.image = UIImage(named: "SHMoFaIcon")
                rightItemView.secondIcon.image = UIImage(named: "songghiColor2Icon")
            }
        }
    }
}
