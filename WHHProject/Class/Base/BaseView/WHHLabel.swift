//
//  WHHLabel.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import UIKit

class WHHLabel: UILabel {
}

extension UILabel {
    
    func whhSetLabel(textContent: String, color: UIColor = .black, numberLine: Int = 0, textFont: UIFont = pingfangLight(size: 14)!, textContentAlignment: NSTextAlignment = .center) {
        text = textContent
        textColor = color
        numberOfLines = numberLine
        font = textFont
        textAlignment = textContentAlignment
    }
}
