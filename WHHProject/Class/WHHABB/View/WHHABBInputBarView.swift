//
//  WHHABBInputBarView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHABBInputBarView: UIView {
    var didInputeSendMsg: ((String) -> Void)?

    lazy var inputTextView: UITextView = {
        let inputTextView = UITextView()
        inputTextView.textColor = Color2C2B2D
        inputTextView.font = pingfangRegular(size: 14)
        inputTextView.returnKeyType = .send
        inputTextView.delegate = self
        inputTextView.backgroundColor = .clear
        inputTextView.text = "输入想占不的内容，或者讲诉一下你今天的烦恼爆点～让阿贝贝为你运用魔法的力量为你解析一下"
        return inputTextView
    }()

    lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: .custom)
        sendButton.setBackgroundImage(UIImage(named: "whhABBInputViewIcon"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        return sendButton
    }()

    lazy var inputBgView: UIView = {
        let inputBgView = UIView()
        inputBgView.backgroundColor = ColorF2F4FE
        inputBgView.layer.cornerRadius = 22
        inputBgView.layer.masksToBounds = true
        inputBgView.layer.borderWidth = 1
        inputBgView.layer.borderColor = Color6C73FF.cgColor

        return inputBgView
    }()

    init() {
        super.init(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        backgroundColor = .clear
        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(inputBgView)
        inputBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(96)
        }

        inputBgView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-60)
        }

        inputBgView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(15)
            make.size.equalTo(36)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        inputTextView.becomeFirstResponder()
    }

    @objc func closeButtonClick() {
        removeFromSuperview()
        inputTextView.resignFirstResponder()
    }

    @objc func sendButtonClick() {
        whhCoreSendMsg()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        print("键盘高度：\(keyboardHeight)")

        inputBgView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-keyboardHeight - 10)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func calculateInputBarHeight() {
        if let inputText = inputTextView.text {
            let minHeight: CGFloat = 66
            let maxHeight: CGFloat = 200

            let inputTextHeight = inputText.whhCalculateLabelHeight(width: WHHScreenW - 32 - 60 - 20, font: pingfangRegular(size: 14)!)
            var indeedBgHeight = inputTextHeight + 24
            // 更新高度
            if indeedBgHeight <= minHeight {
                indeedBgHeight = minHeight
            } else if indeedBgHeight >= maxHeight {
                indeedBgHeight = maxHeight
            }
            inputBgView.snp.updateConstraints { make in
                make.height.equalTo(indeedBgHeight)
            }
        }
    }

    private func whhCoreSendMsg() {
        if let text = inputTextView.text {
            didInputeSendMsg?(text)
            closeButtonClick()

        } else {
            WHHHUD.whhShowInfoText(text: "请输入需要发送的内容")
        }
    }
}

extension WHHABBInputBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        calculateInputBarHeight()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // 检测到Return键（Send按钮）按下
            whhCoreSendMsg()
            return false // 阻止换行
        }
        return true
    }
}
