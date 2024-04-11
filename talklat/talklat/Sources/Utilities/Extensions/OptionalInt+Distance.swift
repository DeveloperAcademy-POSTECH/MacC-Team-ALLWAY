//
//  Double+Distance.swift
//  bisdam
//
//  Created by user on 11/21/23.
//

import Foundation

extension Optional where Wrapped == Double {
    func toStringDistance() -> String {
        guard let distance = self else { return NSLocalizedString("위치 정보 없음", comment: "") }
        
        if distance > 1000 {
            return String(Int(distance / 1000)) + "km"
        } else {
            return String(distance) + "m"
        }
    }
}
