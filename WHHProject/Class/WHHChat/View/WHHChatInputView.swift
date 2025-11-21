//
//  WHHChatInputView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHChatInputView: WHHBaseView {
    lazy var inputTextView: WHHTextView = {
        let view = WHHTextView()
        view.backgroundColor = .clear
        view.textColor = .black
        view.font = pingfangRegular(size: 14)
        view.delegate = self
        view.placeHolder = "请输入文字"
        view.placeHolderColor = Color999999
//        view.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        view.textAlignment = .left
        view.returnKeyType = .send
        return view
    }()

    var didSendMessageBlock: ((WHHChatInputView, String) -> Void)?

    lazy var deleteButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "whhAISendButton"), for: .normal)
        view.addTarget(self, action: #selector(didSendButtonClick), for: .touchUpInside)
        return view
    }()

    lazy var inputContentBgView: WHHBaseView = {
        let view = WHHBaseView()
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()

    override func setupViews() {
        super.setupViews()
        addSubview(inputContentBgView)
        inputContentBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().offset(-19)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        inputContentBgView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
        inputContentBgView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(35)
            make.right.equalTo(deleteButton.snp.left).offset(-5)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(-10)
        }
    }

    @objc func didSendButtonClick() {
        if inputTextView.text.isEmpty {
            WHHHUD.whhShowInfoText(text: "请输入内容")
            return
        }

        didSendMessageBlock?(self, inputTextView.text)
        clearTextContent()
    }

    private func clearTextContent() {
        inputTextView.text = ""
        inputUpdateHeight()
    }
}

extension WHHChatInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        inputTextView.placeHolder = textView.text.isEmpty ? "请输入内容" : ""
        inputUpdateHeight()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            didSendMessageBlock?(self, textView.text)
            clearTextContent()
            return false
        }

        return true
    }

    /// 更新输入框高度
    private func inputUpdateHeight() {
        var inputBgViewHeight = getInputCurrentHeight()

        if inputBgViewHeight <= 35 {
            inputBgViewHeight = 35
        }
        if inputBgViewHeight >= 100 {
            inputBgViewHeight = 100
        }

        inputTextView.snp.updateConstraints { make in
            make.height.equalTo(inputBgViewHeight)
        }
    }

    /// 获取当前的输入框高度
    private func getInputCurrentHeight() -> CGFloat {
        return CGFloat(ceilf(Float(inputTextView.sizeThatFits(inputTextView.frame.size).height)))
    }
}
