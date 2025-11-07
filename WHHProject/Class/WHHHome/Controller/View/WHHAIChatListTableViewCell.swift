//
//  WHHAIChatListTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

import UIKit

class WHHAIChatListTableViewCell: UITableViewCell {
    @IBOutlet weak var centerContentLabel: UILabel!
    
    var didWHHAIChatListTableViewCellButtonBlock:(()->Void)?
    
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func leftButtonClick(_ sender: UIButton) {
        
        didWHHAIChatListTableViewCellButtonBlock?()
    }
}
