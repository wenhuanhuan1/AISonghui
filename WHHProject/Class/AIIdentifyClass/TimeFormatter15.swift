//
//  File.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import Foundation

struct TimeFormatter15 {

    /// 时间戳转字符串
       /// - Parameters:
       ///   - timestamp: 时间戳（秒 or 毫秒）
       ///   - isMillisecond: 是否为毫秒时间戳，默认 false（秒）
       ///   - format: 时间格式，默认 "yyyy-MM-dd HH:mm"
       ///   - timeZone: 时区，默认当前时区
       static func string(
           from timestamp: TimeInterval,
           isMillisecond: Bool = false,
           format: String = "yyyy-MM-dd HH:mm",
           timeZone: TimeZone = .current
       ) -> String {

           let seconds = isMillisecond ? timestamp / 1000 : timestamp
           let date = Date(timeIntervalSince1970: seconds)

           let formatter = DateFormatter()
           formatter.dateFormat = format
           formatter.timeZone = timeZone
           formatter.locale = Locale(identifier: "en_US_POSIX")

           return formatter.string(from: date)
       }
}
