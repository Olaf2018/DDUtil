//
//  DateUtil.swift
//  Expense
//
//  Created by Dream on 2020/5/13.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation

extension Date {

    /// 格式化Date为String
    /// - Parameters:
    ///   - date: 日期
    ///   - format: 格式化字符串，如（yyyy-MM-dd HH:mm:ss）
    /// - Returns: 如果未指定format，默认为"yyyy-MM-dd HH:mm:ss"
    public func format(_ date: Date, format: String?) -> String {
        let formatter = DateFormatter.formatter
        formatter.dateFormat = (format ?? "yyyy-MM-dd HH:mm:ss")
        formatter.timeZone = TimeZone(secondsFromGMT: 8*3600)
        return formatter.string(from: date)
    }

    public func day(_ date: Date) -> String {
        return format(date, format: "MM")
    }
}
