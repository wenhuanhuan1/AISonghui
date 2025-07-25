//
//  WHHHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import GKNavigationBarSwift
import UIKit
class WHHHomeViewController: WHHBaseViewController {
    
    
    lazy var centerItemView: WHHHomeItemView = {
        let centerItemView = WHHHomeItemView()
        centerItemView.bigIconImageView.image = UIImage(named: "whhHomeConstellationIcon")
        centerItemView.witchName.text = "神奇女巫"
        centerItemView.witchName.textColor = Color5A92FF
        centerItemView.witchIconImageView.image = UIImage(named: "whhHomeWonderWitchIcon")
        centerItemView.submitButton.setTitle("星座", for: .normal)
        centerItemView.submitButton.backgroundColor = Color5A92FF
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
    
    lazy var gradualView: WHHGradualView = {
        let gradualView = WHHGradualView()
        gradualView.didActionButtonClick = {
            debugPrint("哈哈哈点击了按钮")
        }
        return gradualView
    }()

    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "whhHomeNavRightIcon"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return rightButton
    }()

    lazy var contentTitle: UILabel = {
        let contentTitle = UILabel()
        contentTitle.text = "whhHomeContentKey".localized
        contentTitle.font = pingfangRegular(size: 14)
        contentTitle.textColor = Color2C2B2D
        contentTitle.numberOfLines = 0
        return contentTitle
    }()

    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "whhHomeBigKey".localized
        bigTitle.font = pingfangRegular(size: 15)
        bigTitle.textColor = Color746CF7
        bigTitle.numberOfLines = 0
        return bigTitle
    }()

    lazy var todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.text = "whhHomeTodayKey".localized
        todayTitle.font = pingfangSemibold(size: 18)
        todayTitle.textColor = Color121212
        todayTitle.numberOfLines = 0
        return todayTitle
    }()

    lazy var dateTitle: UILabel = {
        let dateTitle = UILabel()
        dateTitle.text = "7月3日 周三"
        dateTitle.font = pingfangRegular(size: 14)
        dateTitle.textColor = Color929192
        dateTitle.numberOfLines = 0
        return dateTitle
    }()

    lazy var topBgImageView: WHHBaseImageView = {
        let topBgImageView = WHHBaseImageView()
        topBgImageView.image = UIImage(named: "whhHomeTopBgIcon")
        return topBgImageView
    }()
    
    lazy var buttomBgImageView: WHHBaseImageView = {
        let buttomBgImageView = WHHBaseImageView()
        buttomBgImageView.image = UIImage(named: "whhHomeButtomBgIcon")
        return buttomBgImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        gk_navigationBar.isHidden = true

//        dispatchAfter(delay: 1) {
//            WHHAlertView.initWHHAlertView(title: "whhNetAlertBigTitle".localized, contentText: "whhNetAlertContentTitle".localized, cancleTitle: "whhNetAlertContentRetryTitle".localized, submitTitle: "whhNetAlertContentSettingTitle".localized) { showView in
//                showView.cancleButtonClick()
//            }
//        }

        view.addSubview(topBgImageView)
        topBgImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }

        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        view.addSubview(gradualView)
        gradualView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(topBgImageView.snp.bottom).offset(-20)
        }
        topBgImageView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.right.equalToSuperview().offset(-21)
            make.bottom.equalTo(gradualView.snp.top).offset(-18)
        }
        topBgImageView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.right.equalToSuperview().offset(-21)
            make.bottom.equalTo(contentTitle.snp.top).offset(-6)
        }
        view.addSubview(todayTitle)
        todayTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(rightButton)
        }
        view.addSubview(dateTitle)
        dateTitle.snp.makeConstraints { make in
            make.left.equalTo(todayTitle.snp.right).offset(5)
            make.centerY.equalTo(todayTitle)
        }
        
        view.addSubview(buttomBgImageView)
        buttomBgImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalTo(gradualView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo((WHHScreenW - 16) * 413 / 360)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe-10)
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

    @objc func rightButtonClick() {
        debugPrint("点击了右边的按钮")
    }
}
