//
//  HomeVideoOrPhotoTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/23.
//

import UIKit

class HomeVideoOrPhotoTableViewCell: UITableViewCell {
    @IBOutlet var buttonTitle: UILabel!
    @IBOutlet var smallLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    private(set) var blurView:UIVisualEffectView?
    @IBOutlet weak var sourceBgView: UIView!
    @IBOutlet weak var buttomView: UIView!

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
        }
    }
}
