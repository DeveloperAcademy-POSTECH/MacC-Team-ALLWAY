//
//  Date+Formatter.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation

extension Date {
    public func convertToDate() -> String {
        let currentLocale = Locale.preferredLanguages.first ?? "Language not found"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd (E)"
        dateFormatter.locale = Locale(
            identifier: currentLocale == "en" ? "en" : "ko_KR"
        )
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    public func convertToTime() -> String {
        let currentLocale = Locale.preferredLanguages.first ?? "Language not found"
        let timeFormmatter = DateFormatter()
        timeFormmatter.dateFormat = "a hh:mm"
        timeFormmatter.locale = Locale(
            identifier: currentLocale == "en" ? "en" : "ko_KR"
        )
        let convertedTime = timeFormmatter.string(from: self)
        return convertedTime
    }
}
