//
//  WHHAIWitchTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/24.
//

import UIKit

class WHHAIWitchTableViewCell: UITableViewCell {

    lazy var todayScore: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()

    lazy var todayScoreTitle: UILabel = {
        let view = UILabel()
        view.text = "今日运势"
        view.font = pingfangRegular(size: 10)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()

    lazy var scoreContentTitle: UILabel = {
        let view = UILabel()
        view.text = "100"
        view.font = pingfangSemibold(size: 18)
        view.textColor = Color6D64FF
        view.textAlignment = .center
        return view
    }()

    lazy var augurImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        return view
    }()
    
    lazy var bgView: UIView = {
        let a = UIView()
        a.layer.cornerRadius = 20
        a.layer.masksToBounds = true
        return a
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews()  {
        
        selectionStyle = .none
        layer.cornerRadius = 20
        layer.masksToBounds = true
    
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        
        bgView.addSubview(augurImageView)
        augurImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bgView.addSubview(bottomView)
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

        bottomView.addSubview(todayScore)
        todayScore.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        todayScore.addSubview(todayScoreTitle)
        todayScoreTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }

        todayScore.addSubview(scoreContentTitle)
        scoreContentTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }

    }
    
    var cellModel:WHHHomeWitchModel?{
        
        didSet{
            guard let model = cellModel else { return }
            
            augurImageView.whhSetImageView(url: model.banner)
            
            titleLabel.text = model.name
            
            if model.userFortune.avgScore > 0 {
                // 有日报
                todayScore.isHidden = false
                titleLabel.isHidden = true
                scoreContentTitle.text = "\(model.userFortune.avgScore)"
                desTitleLabel.text = model.userFortune.suggestion
            } else {
                // 没有日报
                titleLabel.isHidden = false
                todayScore.isHidden = true
                desTitleLabel.text = model.meetingWords
            }
        }
        
    }
}
