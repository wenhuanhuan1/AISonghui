//
//  WHHAIDestinyLineItemTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import UIKit

class WHHAIDestinyLineItemTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
