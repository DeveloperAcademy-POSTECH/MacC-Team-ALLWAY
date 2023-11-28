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
    
    func isDoubleEqual(_ a: Double) -> Bool {
        guard let newSelf = Double(String(format: "%.5f", self)) else { return false }
        guard let newDouble = Double(String(format: "%.5f", a)) else { return false}
        return fabs(newSelf - newDouble) < Double.ulpOfOne
    }
}
