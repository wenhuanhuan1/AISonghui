//
//  WHHAboutUsTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit

class WHHAboutUsTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var arraw: UIImageView!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
