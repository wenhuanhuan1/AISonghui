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

        avatarIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10) // 初始布局（assistant）
        }

        inputBgView.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon)
            make.left.equalTo(avatarIcon.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-10)
        }

        chatContent.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12) // 用 >= 就会避免高度问题
        }

        chatContent.numberOfLines = 0
    }

    var cellModel: WHHChatMesageModel? {
        didSet {
            guard let model = cellModel else { return }

            chatContent.text = model.content

            // 清除旧约束
            avatarIcon.snp.remakeConstraints { _ in }
            inputBgView.snp.remakeConstraints { _ in }

            if model.messageType == "user" {
                // 用户消息
                inputBgView.backgroundColor = .white
                avatarIcon.whhSetKFWithImage(imageString: WHHUserInfoManager.shared.userModel.logo)

                // 用户头像在右边
                avatarIcon.snp.remakeConstraints { make in
                    make.size.equalTo(50)
                    make.top.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                }

                inputBgView.snp.remakeConstraints { make in
                    make.top.equalTo(avatarIcon)
                    make.right.equalTo(avatarIcon.snp.left).offset(-10)
                    make.left.greaterThanOrEqualToSuperview().offset(60)
                    make.bottom.equalToSuperview().offset(-10)
                }

            } else {
                // 助手消息
                inputBgView.backgroundColor = ColorD6D4FF
                avatarIcon.image = UIImage(named: "AIDefaultAv")

                avatarIcon.snp.remakeConstraints { make in
                    make.size.equalTo(50)
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(10)
                }

                inputBgView.snp.remakeConstraints { make in
                    make.top.equalTo(avatarIcon)
                    make.left.equalTo(avatarIcon.snp.right).offset(10)
                    make.right.lessThanOrEqualToSuperview().offset(-60)
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
        }
    }
}
