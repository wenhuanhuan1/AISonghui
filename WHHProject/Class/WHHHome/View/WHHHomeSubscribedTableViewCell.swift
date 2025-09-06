//
//  WHHHomeSubscribedTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHHomeSubscribedTableViewCell: UITableViewCell {
    @IBOutlet var gradeBgView: UIView!

    @IBOutlet var goodsDesLabel: UILabel!
    @IBOutlet var goodsLabel: UILabel!
    @IBOutlet var fortuneScoreLabel: UILabel!
    @IBOutlet var bigTitle: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var topConf: NSLayoutConstraint!

    @IBOutlet var heightCon: NSLayoutConstraint!

    @IBOutlet var luckNumberDesLabel: UILabel!
    @IBOutlet var luckNumberLabel: UILabel!
    @IBOutlet var label1: UILabel!

    @IBOutlet var label4: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label2: UILabel!

    @IBOutlet var luckColorDes: UILabel!
    @IBOutlet var luckColor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        topConf.constant = WHHAllNavBarHeight + 14
        heightCon.constant = (WHHScreenW - 40) * 325 / 335
        gradeBgView.layer.cornerRadius = 16
        gradeBgView.layer.masksToBounds = true
        gradeBgView.layer.borderColor = Color4F48CF.whhAlpha(alpha: 0.3).cgColor
        gradeBgView.layer.borderWidth = 1
        detailButton.layer.cornerRadius = 15
        detailButton.layer.masksToBounds = true
    }

    var cellModel: WHHHomeForetellModel? {
        didSet {
            guard let newCellModel = cellModel else { return }

            bigTitle.text = newCellModel.fortune.luckyColorIntroduction
            let att = NSMutableAttributedString(string: newCellModel.fortune.avgScore, attributes: [.font: pingfangSemibold(size: 32)!, .foregroundColor: Color746CF7])
            let sumScore = NSAttributedString(string: "/100", attributes: [.font: pingfangRegular(size: 18)!, .foregroundColor: Color6A6A6B])
            att.append(sumScore)
            fortuneScoreLabel.attributedText = att

            let numberArr = NSMutableAttributedString(string: "幸运数字 ", attributes: [.font: pingfangRegular(size: 12)!, .foregroundColor: Color6A6A6B])
            let number = NSAttributedString(string: newCellModel.fortune.luckyNumber, attributes: [.font: pingfangMedium(size: 12)!, .foregroundColor: Color2C2B2D])
            numberArr.append(number)
            luckNumberLabel.attributedText = numberArr
            luckNumberDesLabel.text = newCellModel.fortune.luckyNumberIntroduction

            let colorArr = NSMutableAttributedString(string: "幸运颜色 ", attributes: [.font: pingfangRegular(size: 12)!, .foregroundColor: Color6A6A6B])
            let color = NSAttributedString(string: newCellModel.fortune.luckyColor, attributes: [.font: pingfangMedium(size: 12)!, .foregroundColor: Color2C2B2D])
            colorArr.append(color)
            luckColor.attributedText = colorArr
            luckColorDes.text = newCellModel.fortune.luckyColorIntroduction

            let goodsArr = NSMutableAttributedString(string: "幸运物品 ", attributes: [.font: pingfangRegular(size: 12)!, .foregroundColor: Color6A6A6B])
            let good = NSAttributedString(string: newCellModel.fortune.luckyGoods, attributes: [.font: pingfangMedium(size: 12)!, .foregroundColor: Color2C2B2D])
            goodsArr.append(good)
            goodsLabel.attributedText = goodsArr
            goodsDesLabel.text = newCellModel.fortune.luckyGoodsIntroduction

            for (index, item) in newCellModel.fortune.items.enumerated() {
                switch index {
                case 0:
                    label1.attributedText = whhReturnAttract(model: item)
                case 1:
                    label2.attributedText = whhReturnAttract(model: item)
                case 2:
                    label3.attributedText = whhReturnAttract(model: item)
                default:
                    label4.attributedText = whhReturnAttract(model: item)
                }
            }
        }
    }

    private func whhReturnAttract(model: WHHHomeForetellItemModel) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: "\(model.title) ", attributes: [.font: pingfangRegular(size: 12)!, .foregroundColor: Color6A6A6B])

        let attr2 = NSAttributedString(string: model.score, attributes: [.font: pingfangMedium(size: 12)!, .foregroundColor: Color2C2B2D])

        let sour = NSAttributedString(string: "/100", attributes: [.font: pingfangRegular(size: 12)!, .foregroundColor: Color6A6A6B])

        attr.append(attr2)
        attr.append(sour)
        return attr
    }
}
