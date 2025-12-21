//
//  WHHNewMineHeaderView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/21.
//

import UIKit

class WHHNewMineHeaderView: WHHBaseView {

    var didEditButtonBlock:(()->Void)?
    
    var didSpackButtonBlock:(()->Void)?
    
    lazy var avatarIcon: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.layer.cornerRadius = 36
        a.layer.masksToBounds = true
        a.layer.borderWidth = 1
        a.layer.borderColor = UIColor.white.cgColor
        return a
    }()
    lazy var editButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("编辑资料", for: .normal)
        a.setTitleColor(.white, for: .normal)
        a.titleLabel?.font = pingfangMedium(size: 12)
        a.backgroundColor = .white.withAlphaComponent(0.3)
        a.layer.cornerRadius = 20
        a.layer.masksToBounds = true
        a.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        return a
    }()
    
    lazy var speackButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("说梦成画", for: .normal)
        a.setTitleColor(.white, for: .normal)
        a.titleLabel?.font = pingfangMedium(size: 12)
        a.backgroundColor = .white.withAlphaComponent(0.3)
        a.layer.cornerRadius = 20
        a.layer.masksToBounds = true
        a.addTarget(self, action: #selector(speakButtonClick), for: .touchUpInside)
        return a
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(editButton)
        addSubview(speackButton)
        editButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        speackButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalTo(editButton.snp.right).offset(16)
            make.width.height.bottom.equalTo(editButton)
        }
        addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(editButton.snp.top).offset(-16)
        }
    }
    
   @objc func editButtonClick() {
        
       didEditButtonBlock?()
    }
    
    @objc func speakButtonClick() {
         
        didSpackButtonBlock?()
     }
}
