//
//  WHHAIDestinyLinesViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit

class WHHAIDestinyLinesViewController: WHHBaseViewController {
    lazy var topView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var topImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.image = UIImage(named: "personVIP")
        return view
    }()

    lazy var getButton: UILabel = {
        let view = UILabel()
        view.text = "获取"
        view.textAlignment = .center
        view.backgroundColor = .white
        view.font = pingfangRegular(size: 13)
        view.textColor = .black
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    lazy var lineLabel: UILabel = {
        let view = UILabel()
        view.text = "命运丝线：0"
        view.textAlignment = .center
        view.font = pingfangRegular(size: 12)
        view.textColor = .white
        return view
    }()

    lazy var bottomView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.5)
        return bgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        gk_navTitle = "命运丝线"
        gk_backStyle = .black
        gk_navTitleColor = .black
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 10)
            make.height.equalTo(170)
        }
        topView.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }

        bottomView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        bottomView.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }

    private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                self?.lineLabel.text = "命运丝线:" + "\(model.luckValueNum)"
            }
        }
    }
}
