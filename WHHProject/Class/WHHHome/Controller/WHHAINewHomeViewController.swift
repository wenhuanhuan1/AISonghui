//
//  WHHAINewHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import Kingfisher
import UIKit

class WHHAINewHomeViewController: WHHBaseViewController {
    lazy var homeView1: UIView = {
        let homeView1 = UIView()
        homeView1.layer.cornerRadius = 20
        homeView1.layer.masksToBounds = true
        homeView1.backgroundColor = .red
        return homeView1
    }()

    lazy var topGetWordButton: UIButton = {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = pingfangRegular(size: 15)
        view.setTitleColor(.black, for: .normal)
        view.layer.cornerRadius = 15
        view.setTitle("获取每日运势", for: .normal)
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(getOneDayWordButtonClick), for: .touchUpInside)
        return view
    }()

    lazy var homeView2: UIView = {
        let homeView2 = UIView()
        homeView2.layer.cornerRadius = 20
        homeView2.layer.masksToBounds = true
        homeView2.backgroundColor = .yellow
        return homeView2
    }()

    lazy var buttomView: UIView = {
        let buttomView = UIView()
        buttomView.backgroundColor = .black.withAlphaComponent(0.5)
        return buttomView
    }()

    lazy var getWordButton: UIButton = {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = pingfangRegular(size: 15)
        view.setTitleColor(.black, for: .normal)
        view.layer.cornerRadius = 15
        view.setTitle("获取未来答案", for: .normal)
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(getWordButtonClick), for: .touchUpInside)
        return view
    }()

    lazy var buttomTitle1: UILabel = {
        let buttomTitle1 = UILabel()
        buttomTitle1.text = "未来等你来问"
        buttomTitle1.textColor = .white
        buttomTitle1.font = pingfangRegular(size: 14)
        return buttomTitle1
    }()

    lazy var homeBgIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.image = UIImage(named: "首页-无日报")
        return view
    }()

    lazy var homeView1MaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()

    lazy var buttomTitle2: UILabel = {
        let buttomTitle2 = UILabel()
        buttomTitle2.text = "任何问题都能获得答案"
        buttomTitle2.textColor = .white
        buttomTitle2.font = pingfangRegular(size: 15)
        return buttomTitle2
    }()

    lazy var topTitle1: UILabel = {
        let view = UILabel()
        view.text = "亲爱的有缘人~\n让阿贝贝能更精准捕捉你今天的命运波纹~\n我们都要知道\n世界上没有不起风的潋滟"
        view.numberOfLines = 0
        view.textColor = .white
        view.font = pingfangRegular(size: 15)
        return view
    }()

    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return rightButton
    }()

    lazy var todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.text = "whhHomeTodayKey".localized
        todayTitle.font = pingfangSemibold(size: 28)
        todayTitle.textColor = Color121212
        todayTitle.numberOfLines = 0
        return todayTitle
    }()

    lazy var dateTitle: UILabel = {
        let dateTitle = UILabel()
        dateTitle.text = "7月3日 周三"
        dateTitle.font = pingfangSemibold(size: 20)
        dateTitle.textColor = Color89898D
        dateTitle.numberOfLines = 0
        return dateTitle
    }()

    lazy var bigIconImageView: AnimatedImageView = {
        let view = AnimatedImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        return view
    }()

    lazy var userAvIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        gk_navigationBar.isHidden = true
        view.addSubview(todayTitle)

        view.addSubview(userAvIcon)
        userAvIcon.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        userAvIcon.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        todayTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(rightButton)
        }
        view.addSubview(dateTitle)
        dateTitle.snp.makeConstraints { make in
            make.left.equalTo(todayTitle.snp.right).offset(5)
            make.bottom.equalTo(todayTitle)
        }
        dateTitle.text = String.getCurrentDateString()

        view.addSubview(homeView1)
        homeView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(rightButton.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
        homeView1.addSubview(homeBgIcon)
        homeBgIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        homeView1.addSubview(homeView1MaskView)
        homeView1MaskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        homeView1.addSubview(topTitle1)
        topTitle1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }

        homeView1.addSubview(topGetWordButton)
        topGetWordButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().offset(-20)
        }

        view.addSubview(homeView2)
        homeView2.snp.makeConstraints { make in
            make.left.right.equalTo(homeView1)
            make.top.equalTo(homeView1.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
        }

        homeView2.addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        homeView2.addSubview(buttomView)
        buttomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        buttomView.addSubview(getWordButton)
        getWordButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        buttomView.addSubview(buttomTitle1)
        buttomTitle1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(15)
        }
        buttomView.addSubview(buttomTitle2)
        buttomTitle2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-15)
        }
        if let path = Bundle.main.path(forResource: "homeView2", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            bigIconImageView.kf.setImage(with: url)
        }
    }

    @objc func getWordButtonClick() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhHomeGetWitchList { [weak self] witchDataArray in
            WHHHUD.whhHidenLoadView()
            if witchDataArray.isEmpty == false {
                self?.jumpABBWitch(array: witchDataArray)
            }
        }
    }

    private func jumpABBWitch(array: [WHHHomeWitchModel]) {
        
        
    
        if let model = array.first(where: { $0.wichId == "2" }) {
            if WHHUserInfoManager.shared.userModel.vip > 0 {
                let abbHomeVC = WHHABBChatViewController()
                abbHomeVC.model = model
                navigationController?.pushViewController(abbHomeVC, animated: true)
            } else {
                WHHHUD.whhShowLoadView()
                FCVIPRequestApiViewModel.whhRequestProductList { [weak self] dataArray in
                    WHHHUD.whhHidenLoadView()
                    let vipView = WHHAIDestinyLineIVIPView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
                    let model = dataArray.first(where: { $0.code == "com.abb.AIProjectWeek" })
                    model?.isSelect = true
                    vipView.dataArray = dataArray
                    self?.view.addSubview(vipView)
                }
            }
        }
    }

    @objc func getOneDayWordButtonClick() {
        let vc = WHHAIChooseAugurViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func rightButtonClick() {
        debugPrint("点击了右边的按钮")

        let personVC = WHHPersonageViewController()

        navigationController?.pushViewController(personVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }

    private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                if model.logo.isEmpty {
                    self?.userAvIcon.image = UIImage(named: "whhAbbBigAvatar")
                } else {
                    self?.userAvIcon.whhSetImageView(url: model.logo)
                }

            } else {
                self?.userAvIcon.image = UIImage(named: "whhAbbBigAvatar")
            }
        }
    }
}
