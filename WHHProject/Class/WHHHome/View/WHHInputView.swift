//
//  WHHInputView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit

class WHHInputView: WHHBaseView {
    lazy var placehodelLabel: UILabel = {
        let placehodelLabel = UILabel()
        placehodelLabel.text = "whhPlacehodelLabelTitleKey".localized
        placehodelLabel.textColor = .white.whhAlpha(alpha: 0.5)
        placehodelLabel.font = pingfangRegular(size: 14)
        return placehodelLabel
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return closeButton
    }()

    lazy var inputTextView: UITextView = {
        let inputTextView = UITextView()
        inputTextView.backgroundColor = .clear
        inputTextView.font = pingfangRegular(size: 14)
        inputTextView.textColor = .white
        inputTextView.returnKeyType = .send
        inputTextView.delegate = self
        return inputTextView
    }()

    lazy var centerView: UIView = {
        let centerView = UIView(frame: CGRectMake((WHHScreenW - 325) / 2, WHHScreenH, 325, 375))
        centerView.layer.cornerRadius = 22
        centerView.layer.masksToBounds = true
        centerView.backgroundColor = Color242132
        centerView.layer.borderWidth = 1
        centerView.layer.borderColor = ColorBDBCC1.cgColor
        return centerView
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.6)

        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(centerView)

        centerView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }

        centerView.addSubview(placehodelLabel)
        placehodelLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }

        // 注册键盘通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        inputTextView.becomeFirstResponder()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        // 获取键盘高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            // 调整界面布局
            UIView.animate(withDuration: 0.3) {
                self.centerView.frame = CGRectMake((WHHScreenW - 325) / 2, WHHScreenH - 375 - keyboardHeight - 10, 325, 375)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func handleSendAction() {
        
        let loadView = WHHLoadAlertView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        addSubview(loadView)
        debugPrint("哈哈哈哈这是输入的文案\(inputTextView.text)")
    }

    @objc func closeButtonClick() {
        removeFromSuperview()
    }
}

extension WHHInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placehodelLabel.isHidden = !textView.text.isEmpty
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // 检测到Return键（Send按钮）按下
            handleSendAction()
            return false // 阻止换行
        }
        return true
    }
}
