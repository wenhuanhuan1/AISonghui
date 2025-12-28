//
//  WHHNewMineItemViewCollectionViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/21.
//

import UIKit

class WHHNewMineItemViewCollectionViewCell: UICollectionViewCell {
    @IBOutlet var zanNumber: UILabel!

    @IBOutlet var playIcon: UIImageView!
    @IBOutlet var bigIcon: UIImageView!
    @IBOutlet var zanIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var cellModel: WHHIntegralModel? {
        didSet {
            guard let model = cellModel else { return }

            if model.type == 2 {
                playIcon.isHidden = false
            } else {
                playIcon.isHidden = true
            }
            bigIcon.whhSetImageView(url: model.coverUrl)

            if model.likeStatus {
                zanIcon.image = UIImage(named: "whhAIZanSelectIcon")
            } else {
                zanIcon.image = UIImage(named: "whhAIZanNormalIcon")
            }
            zanNumber.text = "\(model.likeCnt)"
        }
    }

    @IBAction func zanButtonClick(_ sender: UIButton) {
        guard let model = cellModel else { return }

        if model.likeStatus {
            // 取消

            WHHIdetifyRequestModel.whhPostLikingCancelLikeRequest(type: 1, contentId: model.worksId) { [weak self] code, msg in

                if code == 0 {
                    WHHHUD.whhShowInfoText(text: "取消成功")
                    var model = model
                    model.likeStatus = false
                    model.likeCnt -= 1
                    self?.cellModel = model

                } else {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        } else {
            // 点赞
            WHHIdetifyRequestModel.whhPostLikingLikeRequest(type: 1, contentId: model.worksId) { [weak self] code, msg in

                if code == 0 {
                    var model = model
                    model.likeStatus = true
                    model.likeCnt += 1
                    self?.cellModel = model
                    WHHHUD.whhShowInfoText(text: "点赞成功")
                } else {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        }
    }
}
