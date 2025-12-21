//
//  WHHVIPCenterCollectionViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit

class WHHVIPCenterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bgView: UIView!

    @IBOutlet var vipPrice: UILabel!
    @IBOutlet var vipTitle: UILabel!
    
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
    }

    var cellModel: WHHVIPCenterModel? {
        didSet {
            guard let newCellModel = cellModel else { return }

            vipTitle.text = newCellModel.name

            let attr = NSMutableAttributedString(string: "￥", attributes: [.font: pingfangMedium(size: 14)!, .foregroundColor: UIColor.white])
            let att1 = NSAttributedString(string: newCellModel.price, attributes: [.font: pingfangMedium(size: 22)!, .foregroundColor: UIColor.white])
            attr.append(att1)
            vipPrice.attributedText = attr
            if newCellModel.isSelect {
                bgView.backgroundColor = Color25C5FF.withAlphaComponent(0.1)
                bgView.layer.borderWidth = 2
                bgView.layer.borderColor = Color25C5FF.cgColor
                bottomView.backgroundColor = Color25C5FF
                bottomLabel.textColor = Color0F0F12
            } else {
                bgView.backgroundColor = Color0F0F12.withAlphaComponent(0.3)
                bgView.layer.borderWidth = 0
                bgView.layer.borderColor = UIColor.clear.cgColor
                bottomView.backgroundColor = .white.withAlphaComponent(0.3)
                bottomLabel.textColor = .white.withAlphaComponent(0.5)
            }
            
            var jifen = ""
            if newCellModel.code == "com.abb.AIProjectWeek" {
                jifen = newCellModel.rewardPoints + "积分/周"
            } else if newCellModel.code == "com.abb.AIProjectMonth" {
                jifen = newCellModel.rewardPoints + "积分/月"
            }else if newCellModel.code == "com.abb.AIProjectYears" {
                jifen = newCellModel.rewardPoints + "积分/年"
            }
            bottomLabel.text = jifen
        }
    }
}
