//
//  WHHHomeSubscribedTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHHomeSubscribedTableViewCell: UITableViewCell {
    @IBOutlet var gradeBgView: UIView!

    @IBOutlet var detailButton: UIButton!
    @IBOutlet var topConf: NSLayoutConstraint!

    @IBOutlet var heightCon: NSLayoutConstraint!

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
}
