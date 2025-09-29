//
//  HomeVideoOrPhotoTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/23.
//

import UIKit
import YYImage
import GPUImage

class HomeVideoOrPhotoTableViewCell: UITableViewCell {
    @IBOutlet var buttonTitle: UILabel!
    @IBOutlet var smallLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    private(set) var blurView:UIVisualEffectView?
    @IBOutlet weak var sourceBgView: UIView!
    @IBOutlet weak var buttomView: UIView!
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
    
//    lazy var blurFilter: GPUImageGaussianBlurFilter = {
//        let blurFilter = GPUImageGaussianBlurFilter()
//        blurFilter.blurRadiusInPixels = 1.0 // 可以调整模糊程度
//        return blurFilter
//    }()

    @IBOutlet var starBgView: UIView!
    @IBOutlet var bgConentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bgConentView.layer.cornerRadius = 13
        bgConentView.layer.masksToBounds = true

        starBgView.layer.cornerRadius = 14
        starBgView.layer.masksToBounds = true
        sourceBgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.edges.equalTo(sourceBgView)
        }
        sourceBgView.addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.edges.equalTo(sourceBgView)
        }
       
        buttomView.addGPUImageBlur(radius: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var cellModel: WHHSystemModel? {
        didSet {
            guard let model = cellModel else { return }

            titleLabel.text = model.title
            smallLabel.text = model.content
            buttonTitle.text = model.buttonText
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
