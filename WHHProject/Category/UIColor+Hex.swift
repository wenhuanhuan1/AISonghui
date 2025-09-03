//
//  UIColor+Hex.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

import Foundation

extension UIColor {
    /// 使用十六进制字符串创建UIColor
    /// - Parameters:
    ///   - hex: 支持 "#C9A0DC" / "0xC9A0DC" / "C9A0DC" / "#ABC"
    ///   - alpha: 透明度 (默认 1.0)
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 去掉前缀
        if cString.hasPrefix("0X") { cString.removeFirst(2) }
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        // 处理3位缩写 -> 转成6位
        if cString.count == 3 {
            var full = ""
            for char in cString {
                full.append(char)
                full.append(char)
            }
            cString = full
        }
        
        // 必须是6位
        guard cString.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
