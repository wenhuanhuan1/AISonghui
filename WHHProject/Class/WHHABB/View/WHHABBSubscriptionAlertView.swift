//
//  WHHABBSubscriptionAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHABBSubscriptionAlertView: WHHBaseView {
    lazy var topIcon: WHHBaseImageView = {
        let topIcon = WHHBaseImageView()
        topIcon.image = UIImage(named: "whhShenQiWitchIcon")
        return topIcon
    }()

    var didSubscriptionSubmitButtonClickBlock: ((WHHHomeWitchModel, WHHABBSubscriptionAlertView) -> Void)?

    lazy var witchIcon: WHHBaseImageView = {
        let witchIcon = WHHBaseImageView()
        witchIcon.image = UIImage(named: "whhWitchIcon")
        return witchIcon
    }()

    lazy var witchBottomIcon: WHHBaseImageView = {
        let witchBottomIcon = WHHBaseImageView()
        witchBottomIcon.image = UIImage(named: "witchBottomIcon")
        return witchBottomIcon
    }()

    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        return bottomView
    }()

    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 20
        centerView.layer.masksToBounds = true
        return centerView
    }()

    lazy var witchNameBgIcon: WHHBaseImageView = {
        let witchNameBgIcon = WHHBaseImageView()
        witchNameBgIcon.image = UIImage(named: "whhAbbBgIIocn")
        return witchNameBgIcon
    }()

    lazy var witchColorIcon: WHHBaseImageView = {
        let witchColorIcon = WHHBaseImageView()
        witchColorIcon.image = UIImage(named: "witchColorIcon")
        return witchColorIcon
    }()

    lazy var witchNickName: UILabel = {
        let witchNickName = UILabel()
        witchNickName.text = "神奇女巫·阿贝贝"
        witchNickName.font = pingfangRegular(size: 14)
        witchNickName.textColor = ColorDAAE4D
        return witchNickName
    }()

    lazy var bookName: UILabel = {
        let bookName = UILabel()
        bookName.text = "星座、星象"
        bookName.font = pingfangRegular(size: 10)
        bookName.textColor = Color2C2B2D
        return bookName
    }()

    lazy var colorName: UILabel = {
        let colorName = UILabel()
        colorName.text = "星垂青"
        colorName.font = pingfangRegular(size: 10)
        colorName.textColor = Color2C2B2D
        return colorName
    }()

    lazy var anaName: UILabel = {
        let anaName = UILabel()
        anaName.text = "巫语录"
        anaName.font = pingfangRegular(size: 8)
        anaName.textColor = Color6A6A6B
        return anaName
    }()

    lazy var anaContentName: UILabel = {
        let anaContentName = UILabel()
        anaContentName.text = "让我用魔法球为你照亮前程~"
        anaContentName.font = pingfangRegular(size: 10)
        anaContentName.textColor = Color2C2B2D
        return anaContentName
    }()

    lazy var welfareContentName: UILabel = {
        let view = UILabel()
        view.text = "订阅福利：\n·每天6:66准时推送（别问为什么是这个时间）\n ·附赠每天一次的突发事件修正预言"
        view.font = pingfangSemibold(size: 12)
        view.textColor = .white
        view.numberOfLines = 0
        return view
    }()

    lazy var bookNameTips: UILabel = {
        let bookNameTips = UILabel()
        bookNameTips.text = "擅长"
        bookNameTips.font = pingfangRegular(size: 8)
        bookNameTips.textColor = Color6A6A6B
        return bookNameTips
    }()

    lazy var subscriptionAndDivination: UILabel = {
        let subscriptionAndDivination = UILabel()
        subscriptionAndDivination.text = "订阅： 123人  占卜：123次"
        subscriptionAndDivination.font = pingfangRegular(size: 8)
        subscriptionAndDivination.textColor = Color2C2B2D
        return subscriptionAndDivination
    }()

    lazy var forecastReturnTitle: UILabel = {
        let forecastReturnTitle = UILabel()
        forecastReturnTitle.text = "亲爱的，想每天睁开眼就收到来自魔法世界的专属预言吗？\n订阅「占卜日报」，让我用魔法球为你提前探路——事业陷阱、桃花方位、财运波动...连你早上该喝咖啡还是红茶都能算准！"
        forecastReturnTitle.font = pingfangRegular(size: 13)
        forecastReturnTitle.textColor = Color2C2B2D
        forecastReturnTitle.numberOfLines = 0
        return forecastReturnTitle
    }()

    lazy var colorTips: UILabel = {
        let colorTips = UILabel()
        colorTips.text = "擅长"
        colorTips.font = pingfangRegular(size: 8)
        colorTips.textColor = Color6A6A6B
        return colorTips
    }()

    lazy var contractLabel: UILabel = {
        let contractLabel = UILabel()
        contractLabel.text = "契约代价：只需要你的一个订阅支持~"
        contractLabel.font = pingfangRegular(size: 10)
        contractLabel.textColor = Color2C2B2D
        contractLabel.textAlignment = .center
        return contractLabel
    }()

    lazy var witchBookIcon: WHHBaseImageView = {
        let witchBookIcon = WHHBaseImageView()
        witchBookIcon.image = UIImage(named: "whhBookIcon")
        return witchBookIcon
    }()

    lazy var welfareIcon: WHHBaseImageView = {
        let welfareIcon = WHHBaseImageView()
        welfareIcon.image = UIImage(named: "whhsubscriptionWelfareIcon")
        return welfareIcon
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

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "取消订阅"
        titleLabel.font = pingfangSemibold(size: 16)
        titleLabel.textColor = Color2C2B2D
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setImage(UIImage(named: "subscriptionManagerIcon"), for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    var model: WHHHomeWitchModel? {
        didSet {
            guard let tempModel = model else { return }
            witchIcon.whhSetImageView(url: tempModel.icon)
            witchNickName.text = tempModel.name + " · 贝贝"
            forecastReturnTitle.text = tempModel.meetingWords
            var name1 = ""
            if let welfares1 = tempModel.welfares.first {
                name1 = welfares1
            }
            if let welfares2 = tempModel.welfares.last {
                name1 += "\n" + welfares2
            }
            welfareContentName.text = name1

            subscriptionAndDivination.text = "订阅: \(tempModel.stat.subscribeTimes)人" + " " + "占卜: \(tempModel.stat.fortuneTimes)次"
            anaContentName.text = tempModel.quotes
            bookName.text = tempModel.goodAt
            colorName.text = tempModel.luckyColor
            if tempModel.subscribed {
                submitButton.setTitle("已订阅", for: .normal)
            } else {
                submitButton.setTitle("订阅", for: .normal)
            }
        }
    }

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.6)
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(485)
        }
        centerView.addSubview(topIcon)
        topIcon.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(183)
        }

        centerView.addSubview(witchIcon)
        witchIcon.snp.makeConstraints { make in
            make.width.equalTo(142)
            make.height.equalTo(136)
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(23)
        }
        centerView.addSubview(witchNameBgIcon)

        witchNameBgIcon.snp.makeConstraints { make in
            make.left.equalTo(witchIcon.snp.right).offset(18)
            make.width.equalTo(131)
            make.height.equalTo(23)
            make.top.equalToSuperview().offset(25)
        }
        witchNameBgIcon.addSubview(witchNickName)
        witchNickName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }

        centerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(167)
        }

        bottomView.addSubview(witchBottomIcon)
        witchBottomIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topIcon.addSubview(witchBookIcon)
        witchBookIcon.snp.makeConstraints { make in
            make.left.equalTo(witchIcon.snp.right).offset(18)
            make.size.equalTo(22)
            make.top.equalTo(witchNameBgIcon.snp.bottom).offset(12)
        }

        topIcon.addSubview(bookName)
        bookName.snp.makeConstraints { make in
            make.left.equalTo(witchBookIcon.snp.right).offset(2)
            make.top.equalTo(witchBookIcon.snp.top).offset(-2)
        }
        topIcon.addSubview(bookNameTips)
        bookNameTips.snp.makeConstraints { make in
            make.left.equalTo(witchBookIcon.snp.right).offset(2)
            make.top.equalTo(bookName.snp.bottom).offset(0)
        }
        topIcon.addSubview(witchColorIcon)
        witchColorIcon.snp.makeConstraints { make in
            make.left.equalTo(witchBookIcon)
            make.size.equalTo(22)
            make.top.equalTo(witchBookIcon.snp.bottom).offset(10)
        }

        topIcon.addSubview(colorName)
        colorName.snp.makeConstraints { make in
            make.left.equalTo(witchColorIcon.snp.right).offset(2)
            make.top.equalTo(witchColorIcon.snp.top).offset(-2)
        }
        topIcon.addSubview(colorTips)
        colorTips.snp.makeConstraints { make in
            make.left.equalTo(witchColorIcon.snp.right).offset(2)
            make.top.equalTo(colorName.snp.bottom).offset(0)
        }

        topIcon.addSubview(anaName)
        anaName.snp.makeConstraints { make in
            make.left.equalTo(witchColorIcon)
            make.top.equalTo(witchColorIcon.snp.bottom).offset(5)
        }
        topIcon.addSubview(anaContentName)
        anaContentName.snp.makeConstraints { make in
            make.left.equalTo(anaName)
            make.top.equalTo(anaName.snp.bottom).offset(0)
        }

        topIcon.addSubview(subscriptionAndDivination)
        subscriptionAndDivination.snp.makeConstraints { make in
            make.left.equalTo(anaContentName)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(anaContentName.snp.bottom).offset(6)
        }

        bottomView.addSubview(forecastReturnTitle)
        forecastReturnTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.top.equalToSuperview().offset(8)
        }

        bottomView.addSubview(welfareIcon)
        welfareIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.height.equalTo(110)
            make.top.equalTo(forecastReturnTitle.snp.bottom).offset(12)
        }
        welfareIcon.addSubview(welfareContentName)
        welfareContentName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        bottomView.addSubview(contractLabel)
        contractLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welfareIcon.snp.bottom).offset(8)
        }

        bottomView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-15)
        }
        bottomView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-18)
            make.width.height.bottom.equalTo(backButton)
        }
    }

    @objc func backButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
        guard let newModel = model else { return }
        didSubscriptionSubmitButtonClickBlock?(newModel, self)
    }
}
