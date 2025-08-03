//
//  WHHControllTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHControllTableViewCell: UITableViewCell {
    @IBOutlet var lineView: UIView!
    @IBOutlet var leftTitleLabel: UILabel!
    @IBOutlet var leftIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var dict: [String: Any]? {
        didSet {
            guard let tempDict = dict else { return }
            if let isHiddenLine = tempDict["isHiddenLine"] as? Bool {
                lineView.isHidden = isHiddenLine
            }
            if let leftIconString = tempDict["leftIconString"] as? String {
                leftIcon.image = UIImage(named: leftIconString)
            }
            if let leftTitleString = tempDict["leftTitleString"] as? String {
                leftTitleLabel.text = leftTitleString
            }
        }
    }
}
