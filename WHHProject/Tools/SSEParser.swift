//
//  qwqw.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/9.
//

import Foundation

final class SSEParser {
    /// ✅ 仅提取第一个 data: 段
       static func extractSingle(from text: String) -> String? {
           guard let range = text.range(of: "data:") else { return nil }
           let raw = String(text[range.upperBound...])
           return clean(raw)
       }

       /// ✅ 提取多个 data: 段（多行、多条流式响应）
       static func extractMultiple(from text: String) -> [String] {
           let pattern = #"data:(.*?)\n\n"#
           guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
               return []
           }
           let nsText = text as NSString
           return regex.matches(in: text, range: NSRange(location: 0, length: nsText.length)).map {
               let raw = nsText.substring(with: $0.range(at: 1))
               return clean(raw)
           }
       }

       /// ✅ 清理字符串中的 `data:` 前缀、空格、换行
       static func clean(_ text: String) -> String {
           return text
               .replacingOccurrences(of: #"data:\n\n"#, with: "", options: .regularExpression)
               .trimmingCharacters(in: .whitespacesAndNewlines)
       }
}
