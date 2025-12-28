//
//  WHHJIfenListTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/21.
//

import UIKit

class WHHJIfenListTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var listTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var cellModel:WHHIntegralModel?{
        
        didSet {
            
            guard let model = cellModel else { return }
            
            listTitle.text = model.remark
            if model.income {
                numberLabel.text = "+" + model.num
            }else{
                numberLabel.text = "-" + model.num
            }
            
            timerLabel.text = TimeFormatter15.string(from: model.createTime,isMillisecond: true)
        }
        
    }
    
}
