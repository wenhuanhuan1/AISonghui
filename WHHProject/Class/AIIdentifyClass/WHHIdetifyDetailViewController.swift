//
//  WHHIdetifyDetailViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import UIKit

class WHHIdetifyDetailViewController: WHHBaseViewController {
    lazy var moreButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "AIDetaiMoreIcon"), for: .normal)
        a.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return a
    }()
    
    lazy var leftBackButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage.gk_image(with: "btn_back_black"), for: .normal)
        a.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var avatarIcon: WHHBaseImageView = {
        let avatarIcon = WHHBaseImageView()
        avatarIcon.layer.borderWidth = 1
        avatarIcon.layer.borderColor = UIColor.white.cgColor
        avatarIcon.layer.cornerRadius = 16
        avatarIcon.backgroundColor = .red
        return avatarIcon
    }()

    lazy var nickName: UILabel = {
        let a = UILabel()
        a.textColor = .white
        a.font = pingfangSemibold(size: 16)
        a.text = "Gloria"
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        
        view.addSubview(leftBackButton)
        leftBackButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        view.addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.size.equalTo(32)
            make.centerY.equalTo(leftBackButton)
        }
        view.addSubview(nickName)
        nickName.snp.makeConstraints { make in
            make.centerY.equalTo(avatarIcon)
            make.left.equalTo(avatarIcon.snp.right).offset(12)
        }
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalTo(leftBackButton)
        }
    }

    @objc func moreButtonClick() {
        let reportView = WHHIdetifyDetailReportView().whhLoadXib()

        reportView.didReportButtonClick = { _ in
            
            
        }
        view.addSubview(reportView)
    }
    
    @objc func backButtonClick() {
        
        navigationController?.popViewController(animated: true)
    }
}
