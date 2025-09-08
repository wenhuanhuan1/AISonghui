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
        view.layer.cornerRadius = 18
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
            avatarIcon.whhSetImageView(url: model.icon)
            chatContent.text = model.chatContent
            if model.messageDirection == .send {
                inputBgView.backgroundColor = .white
                avatarIcon.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-12)
                    make.top.equalToSuperview().offset(14)
                    make.size.equalTo(36)
                }
                inputBgView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(70)
                    make.right.equalTo(avatarIcon.snp.left).offset(-7)
                    make.top.equalTo(avatarIcon)
                    make.bottom.equalToSuperview()
                }

            } else if model.messageDirection == .receive {
                inputBgView.backgroundColor = ColorD6D4FF
                avatarIcon.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(12)
                    make.top.equalToSuperview().offset(14)
                    make.size.equalTo(36)
                }
                inputBgView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-70)
                    make.left.equalTo(avatarIcon.snp.right).offset(7)
                    make.top.equalTo(avatarIcon)
                    make.bottom.equalToSuperview()
                }
            }

           
        }
    }
}
