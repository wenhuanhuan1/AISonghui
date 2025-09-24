//
//  HomeABBTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/23.
//

import UIKit

class HomeABBTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceImageView: UIImageView!
    lazy var bigIconImageView: YYAnimatedImageView = {
        let view = YYAnimatedImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        return view
    }()

    lazy var iconImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.isHidden = true
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        sourceImageView.layer.cornerRadius = 13
        sourceImageView.layer.masksToBounds = true

    
        sourceImageView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.edges.equalTo(sourceImageView)
        }
        sourceImageView.addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.edges.equalTo(sourceImageView)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var cellModel: WHHSystemModel? {
        didSet {
            guard let model = cellModel else { return }

            titleLabel.text = model.content
            if model.type == 1 {
                iconImageView.isHidden = true
                bigIconImageView.isHidden = false
                WebPManager.loadNetWebUrl(model.assetUrl, display: bigIconImageView)
            } else if model.type == 3 {
                iconImageView.isHidden = false
                bigIconImageView.isHidden = true
                iconImageView.whhSetKFWithImage(imageString: model.assetUrl)
            }
        }
    }
}
