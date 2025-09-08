//
//  WHHTextView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHTextView: UITextView {
    private lazy var placeHolderLabel: WHHLabel = {
        let view = WHHLabel()
        view.whhSetLabel(textContent: "请输入文字", color: .lightGray, numberLine: 1, textFont: pingfangRegular(size: 14)!, textContentAlignment: .left)
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    var placeHolder: String? {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }

    var placeHolderColor: UIColor? {
        didSet {
            placeHolderLabel.textColor = placeHolderColor
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
