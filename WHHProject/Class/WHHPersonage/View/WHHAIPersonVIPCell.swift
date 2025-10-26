//
//  WHHAIPersonVIPCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit

class WHHAIPersonVIPCell: UITableViewCell {

    lazy var status: UILabel = {
        let view = UILabel()
        view.text = "未开通"
        view.textAlignment = .center
        view.backgroundColor = .black
        view.font = pingfangRegular(size: 12)
        view.textColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var getButton: UILabel = {
        let view = UILabel()
        view.text = "获取"
        view.textAlignment = .center
        view.backgroundColor = .white
        view.font = pingfangRegular(size: 13)
        view.textColor = .black
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var lineLabel: UILabel = {
        let view = UILabel()
        view.text = "命运丝线：0"
        view.textAlignment = .center
        view.font = pingfangRegular(size: 12)
        view.textColor = .white
        return view
    }()
    
    
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bottomView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.5)
        return bgView
    }()
    
    lazy var icon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.image = UIImage(named: "personVIP")
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview()
        }
        bgView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.addSubview(status)
        status.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        bgView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        bottomView.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
