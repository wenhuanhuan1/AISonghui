//
//  WHHAITextView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/25.
//

import UIKit

protocol WHHAITextViewDelegate:AnyObject {
    
    func whhAItextViewDidChange(_ textView: UITextView)
}

class WHHAITextView: UITextView {
    
    weak var whhDelegate:WHHAITextViewDelegate?
    
    lazy var placeholderLabel: UILabel = {
        let a = UILabel()
        a.textColor = .white.withAlphaComponent(0.9)
        a.font = pingfangMedium(size: 16)
        a.text = "请输入文案"
        return a
    }()
    
    init() {
        super.init(frame: .zero, textContainer: .none)
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension WHHAITextView:UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        if (whhDelegate != nil) {
            whhDelegate?.whhAItextViewDidChange(textView)
        }
    }
    
}
