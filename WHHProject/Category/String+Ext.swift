//
//  String+Ext.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import Foundation

extension String {
    
    /// 根据宽度去计算文本高度
    /// - Parameters:
    ///   - width: 一直的宽度
    ///   - font: 字体
    /// - Returns: 返回高度
    func whhCalculateLabelHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
