//
//  Double+Degree.swift
//  talklat
//
//  Created by Celan on 2023/10/10.
//

import Foundation

extension Double {
    func toDegrees() -> Double {
        return 180 / Double.pi * self
    }
    
    func toRadians() -> Double {
        return self * Double.pi / 180
    }
}
