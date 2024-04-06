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
        dateFormatter.dateFormat = currentLocale == "en" ? "MMMM d, yyyy" : "yyyy.MM.dd (E)"
        dateFormatter.locale = Locale(identifier: currentLocale == "en" ? "en_US" : "ko_KR")
                
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    public func convertToTime() -> String {
        let currentLocale = Locale.preferredLanguages.first ?? "Language not found"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = currentLocale == "en" ? "h:mm a" : "a hh:mm"
        timeFormatter.locale = Locale(identifier: currentLocale == "en" ? "en_US" : "ko_KR")
                
        let convertedTime = timeFormatter.string(from: self)
        return convertedTime
    }
}
