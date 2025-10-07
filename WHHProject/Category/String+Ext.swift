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
    
    /// 获取当前日期字符串，格式: 7月 23日 周三
    static func getCurrentDateString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN") // 中文
        formatter.dateFormat = "M月 d日 E"            // M=月, d=日, E=星期几
        return formatter.string(from: now)
    }
}
