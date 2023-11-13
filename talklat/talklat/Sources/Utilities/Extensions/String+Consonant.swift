//
//  String+Consonant.swift
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

extension Character {
    // 한글 첫 자음 추출 (쌍자음 포함)
    var koreanFirstConsonant: String? {
        let hangulStart: UInt32 = 0xAC00 // '가'
        let initialConsonants = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]

        guard let scalarValue = UnicodeScalar(String(self))?.value else { return nil }
        if scalarValue >= hangulStart, scalarValue <= 0xD7A3 {
            let index = Int((scalarValue - hangulStart) / 588)
            return initialConsonants[min(index, initialConsonants.count - 1)]
        }
        return nil
    }
}
