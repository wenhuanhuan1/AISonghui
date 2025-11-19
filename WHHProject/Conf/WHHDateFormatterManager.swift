//
//  WHHDateFormatterManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/19.
//

import UIKit

class WHHDateFormatterManager {
    static let shared = WHHDateFormatterManager()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current       // 使用当前时区
        formatter.dateFormat = "yyyy-MM-dd"
    }

    /// 时间戳转 yyyy-MM-dd
    func convertTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return formatter.string(from: date)
    }
}
