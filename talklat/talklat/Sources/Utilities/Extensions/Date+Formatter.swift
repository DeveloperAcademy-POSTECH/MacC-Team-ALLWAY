//
//  Date+Formatter.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation

extension Date {
    public func convertToDate(_ localeType: LocaleType? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        
        if let localeType = localeType {
            switch localeType {
            case .korean:
                dateFormatter.locale = Locale(identifier: "ko_KR")
            default:
                dateFormatter.locale = Locale.current
            }
        }
        
        return dateFormatter.string(from: self)
    }
    
    
    public func convertToTime(_ localeType: LocaleType? = nil) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale.current
        
        if let localeType = localeType {
            switch localeType {
            case .korean:
                timeFormatter.locale = Locale(identifier: "ko_KR")
            default:
                timeFormatter.locale = Locale.current
            }
        }
        
        return timeFormatter.string(from: self)
    }
}
