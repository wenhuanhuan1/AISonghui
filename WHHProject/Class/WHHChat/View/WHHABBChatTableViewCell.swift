//
//  WHHABBChatTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHABBChatTableViewCell: WHHBaseTableViewCell {
    lazy var avatarIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var inputBgView: WHHBaseView = {
        let view = WHHBaseView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    lazy var chatContent: WHHLabel = {
        let chatContent = WHHLabel()
        chatContent.whhSetLabel(textContent: "哈哈哈这是聊天内容哈哈哈你在干什么啊哈哈哈哈啊哈哈", color: Color2C2B2D, numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .left)
        return chatContent
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
        backgroundColor = .clear
        contentView.addSubview(avatarIcon)
        contentView.addSubview(inputBgView)
        inputBgView.addSubview(chatContent)
        chatContent.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }

    var cellModel: WHHChatMesageModel? {
        didSet {
            guard let model = cellModel else { return }

            chatContent.text = model.content
            if model.messageType == "user" {
                inputBgView.backgroundColor = .white

                avatarIcon.whhSetKFWithImage(imageString: WHHUserInfoManager.shared.userModel.logo)
                
                avatarIcon.snp.remakeConstraints { make in
                    make.size.equalTo(50)
                    make.top.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                }

                inputBgView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(60)
                    make.right.equalTo(avatarIcon.snp.left).offset(-10)
                    make.top.equalTo(avatarIcon)
                    make.bottom.equalToSuperview().offset(-10)
                }

            } else if model.messageType == "assistant" {
                inputBgView.backgroundColor = ColorD6D4FF

                avatarIcon.image = UIImage(named: "AIDefaultAv")
                avatarIcon.snp.remakeConstraints { make in
                    make.size.equalTo(50)
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(10)
                }

                inputBgView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-60)
                    make.left.equalTo(avatarIcon.snp.right).offset(10)
                    make.top.equalTo(avatarIcon)
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
        }
    }
}
