//
//  WHHHomeNoSubscriptionCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHHomeNoSubscriptionCell: WHHBaseTableViewCell {
    lazy var topBgImageView: WHHBaseImageView = {
        let topBgImageView = WHHBaseImageView()
        topBgImageView.image = UIImage(named: "whhHomeTopBgIcon")
        return topBgImageView
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

    lazy var gradualView: WHHGradualView = {
        let gradualView = WHHGradualView()
        gradualView.didActionButtonClick = { [weak self] in
            debugPrint("哈哈哈点击了按钮")
            let divinationVC = WHHDivinationViewController()
            if let vc = UIViewController.currentViewController() {
                vc.navigationController?.pushViewController(divinationVC, animated: true)
            }
        }
        return gradualView
    }()

   
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(topBgImageView)
        topBgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(gradualView)
        gradualView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
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
    }
}
