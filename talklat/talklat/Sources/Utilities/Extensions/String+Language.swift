//
//  String+Language.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import Foundation
import SwiftUI

extension String {
    var headerKey: String {
        guard let firstChar = self.first else { return "#" }


        switch firstChar {
        case let c where c.isKorean:
            return c.koreanFirstConsonant ?? "#"
        case let c where c.isEnglish:
            return String(c).uppercased()
        default:
            return "#"
        }
    }
}
