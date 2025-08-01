//
//  WHHAgainAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit

class WHHAgainAlertView: UIView {
 
    
    init() {
        super.init(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        backgroundColor = .black.whhAlpha(alpha: 0.6)
        let centerView = UIView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(225)
            make.center.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "请勿重复提交"
        titleLabel.textAlignment = .center
        titleLabel.textColor = Color2C2B2D
        titleLabel.font = pingfangSemibold(size: 16)
        centerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(32)
        }
        let desLabel = UILabel()
        desLabel.text = "水晶球通讯次数有限\n今天已经提交过一次，明日再来"
        desLabel.textAlignment = .center
        desLabel.numberOfLines = 0
        desLabel.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        desLabel.font = pingfangRegular(size: 16)
        centerView.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
        backButton.titleLabel?.font = pingfangRegular(size: 14)
        backButton.setTitleColor(Color2C2B2D, for: .normal)
        backButton.backgroundColor = ColorEDEBEF
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        centerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonClick(_ sender: UIButton) {
        removeFromSuperview()
    }
}
