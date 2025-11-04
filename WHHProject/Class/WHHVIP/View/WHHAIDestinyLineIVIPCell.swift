//
//  WHHAIDestinyLineIVIPCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import UIKit

class WHHAIDestinyLineIVIPCell: UITableViewCell {

    @IBOutlet weak var openWenDa: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var bgsasView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bgsasView.layer.cornerRadius = 35
        bgsasView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
