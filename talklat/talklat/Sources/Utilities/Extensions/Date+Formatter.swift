//
//  Date+Formatter.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation

extension Date {
    public func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: self)
    }
    
    
    public func convertToTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale.current
        
        return timeFormatter.string(from: self)
    }
}
