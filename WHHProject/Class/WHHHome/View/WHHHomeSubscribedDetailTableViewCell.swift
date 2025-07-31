//
//  WHHHomeSubscribedDetailTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit

class WHHHomeSubscribedDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel2: UILabel!
    
    @IBOutlet weak var contentLabel1: UILabel!
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
