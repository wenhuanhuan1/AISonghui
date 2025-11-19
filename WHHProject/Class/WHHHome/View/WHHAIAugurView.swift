//
//  WHHAIAugurView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit

enum WHHAIAugurViewType {
case zhiming
    case xuanji
    case siye
}

class WHHAIAugurView: UIView {

    var didWHHAIAugurViewButtonBlock:(()->Void)?
    
    lazy var didButton: UIButton = {
        let view = UIButton(type: .custom)
        view.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var augurImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        return view
    }()
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "织命"
        view.font = pingfangSemibold(size: 16)
        return view
    }()
    
    lazy var desTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "今日命运之线已绷紧如弦。是避开厄运，还是走向注定结局？我从不撒谎，只揭示精准的残酷。"
        view.numberOfLines = 0
        view.font = pingfangRegular(size: 13)
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    

    init(type:WHHAIAugurViewType) {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        addSubview(augurImageView)
        augurImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.left.equalToSuperview().offset(10)
        }
        bottomView.addSubview(desTitleLabel)
        desTitleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        if type == .zhiming {
            titleLabel.text = "织命"
            desTitleLabel.text = "今日命运之线已绷紧如弦。是避开厄运，还是走向注定结局？我从不撒谎，只揭示精准的残酷。"
            augurImageView.image = UIImage(named: "织命")
        
        }else if type == .xuanji {
            titleLabel.text = "璇玑"
            desTitleLabel.text = "今日天机已动，缘者得窥一线玄光。卦不敢算尽，畏天道无常，可为你点破吉凶进退之机。"
            augurImageView.image = UIImage(named: "璇玑")

        }else if type == .siye {
            titleLabel.text = "司夜"
            desTitleLabel.text = "她的水晶已映出你今日的灾厄——若你甘愿承受这愚行带来的苦果，便请继续无知的前行。"
            augurImageView.image = UIImage(named: "司夜")

        }
        addSubview(didButton)
        didButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadOtherUIS() {
        
        
       
        
    }
    
    @objc func didButtonClick() {
        
        didWHHAIAugurViewButtonBlock?()
    }
}
