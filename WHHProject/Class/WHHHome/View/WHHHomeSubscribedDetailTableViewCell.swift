//
//  WHHHomeSubscribedDetailTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit

class WHHHomeSubscribedDetailTableViewCell: UITableViewCell {
    @IBOutlet var contentLabel2: UILabel!

    @IBOutlet var topIcon: UIImageView!
    @IBOutlet var smallIcon: UIImageView!
    @IBOutlet var contentLabel1: UILabel!
    @IBOutlet var icon: UIView!
    @IBOutlet var bigTitle: UILabel!
    @IBOutlet var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var cellModel: WHHHomeForetellItemModel? {
        didSet {
            guard let newCellModel = cellModel else { return }
            bigTitle.attributedText = titleAttr(title: newCellModel.title + " " + newCellModel.score)

            let goodLuck = NSMutableAttributedString(string: "好运 ", attributes: [.font: pingfangMedium(size: 14)!, .foregroundColor: Color2C2B2D])
            let sumScore = NSAttributedString(string: "/\(newCellModel.goodLuck)", attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: Color2C2B2D])
            goodLuck.append(sumScore)

            contentLabel1.attributedText = goodLuck

            let badLuck = NSMutableAttributedString(string: "坏运 ", attributes: [.font: pingfangMedium(size: 14)!, .foregroundColor: Color2C2B2D])
            let badSumScore = NSAttributedString(string: "/\(newCellModel.goodLuck)", attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: Color2C2B2D])
            badLuck.append(badSumScore)

            contentLabel2.attributedText = badLuck

            switch newCellModel.title {
            case "事业":
                smallIcon.image = UIImage(named: "whhHomePagIcon")
                topIcon.image = UIImage(named: "whhShiyeIcon")
            case "感情":
                smallIcon.image = UIImage(named: "whhHomeHeartIcon")
                topIcon.image = UIImage(named: "whhGanqingIcon")
            case "财运":
                smallIcon.image = UIImage(named: "whhHomeCoinIcon")
                topIcon.image = UIImage(named: "whhCaiyunIcon")
            default:
                smallIcon.image = UIImage(named: "whhHomeHealthIcon")
                topIcon.image = UIImage(named: "whhJianKangIcon")
            }
        }
    }

    private func titleAttr(title: String) -> NSAttributedString {
        let att = NSMutableAttributedString(string: title, attributes: [.font: pingfangMedium(size: 14)!, .foregroundColor: Color2C2B2D])
        let sumScore = NSAttributedString(string: "/100", attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: Color2C2B2D])
        att.append(sumScore)
        return att
    }
}
