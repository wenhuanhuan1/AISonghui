//
//  WHHGradualView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/24.
//

import UIKit

class WHHGradualView: WHHBaseView {
    var didActionButtonClick: (() -> Void)?

    
 
    
    lazy var rightIcon: WHHBaseImageView = {
        let rightIcon = WHHBaseImageView()
        rightIcon.image = UIImage(named: "whhHomeDivinationIcon")
        return rightIcon
    }()

    lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .custom)
        actionButton.addTarget(self, action: #selector(actionButtonClick), for: .touchUpInside)
        return actionButton
    }()

    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "whhHomeDivinationKey".localized
        title.textAlignment = .center
        title.font = pingfangSemibold(size: 18)
        title.textColor = .white
        return title
    }()

    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 25
        layer.masksToBounds = true
        addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.right.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
        }
        addSubview(title)
        title.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyGradient(colours: [Color67A9FF,Color6D64FF], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
    }

    @objc func actionButtonClick() {
        didActionButtonClick?()
    }
    
   
}
