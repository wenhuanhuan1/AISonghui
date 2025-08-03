//
//  WHHVIPCenterCollectionViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit

class WHHVIPCenterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var selctIcon: UIImageView!
    @IBOutlet var bgView: UIView!

    @IBOutlet var vipPrice: UILabel!
    @IBOutlet var vipTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
    }

    var cellModel: WHHVIPCenterModel? {
        didSet {
            guard let newCellModel = cellModel else { return }

            vipTitle.text = newCellModel.title

            let attr = NSMutableAttributedString(string: "￥", attributes: [.font: pingfangMedium(size: 14)!, .foregroundColor: UIColor.white])
            let att1 = NSAttributedString(string: newCellModel.price, attributes: [.font: pingfangMedium(size: 22)!, .foregroundColor: UIColor.white])
            attr.append(att1)
            vipPrice.attributedText = attr
            if newCellModel.isSelect {
                selctIcon.isHidden = false
                bgView.layer.borderWidth = 2
                bgView.layer.borderColor = ColorFEF5E6.cgColor
            } else {
                selctIcon.isHidden = true
                bgView.layer.borderWidth = 0
                bgView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
