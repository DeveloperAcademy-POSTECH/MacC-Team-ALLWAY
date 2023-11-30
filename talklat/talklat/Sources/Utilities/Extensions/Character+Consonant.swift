//
//  Character+Consonant.swift
//  talklat
//
//  Created by 신정연 on 11/14/23.
//

import Foundation
import SwiftUI

extension Character {
    // 한글 첫 자음 추출 (쌍자음 포함)
    var koreanFirstConsonant: String? {
        let hangulStart: UInt32 = 0xAC00 // '가'의 스칼라값
        let initialConsonants = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        let consonantStart: UInt32 = 0x3131 // 'ㄱ'의 스칼라값
        let consonantEnd: UInt32 = 0x314E // 'ㅎ'의 스칼라값

        guard let scalarValue = UnicodeScalar(String(self))?.value else { return nil }

        // 단일 자음 처리
        if scalarValue >= consonantStart, scalarValue <= consonantEnd {
            let index = Int(scalarValue - consonantStart)
            if index < initialConsonants.count {
                return initialConsonants[index]
            }
        }
        
        // 완성형 한글 범위 내의 처리
        if scalarValue >= hangulStart, scalarValue <= 0xD7A3 {
            let index = Int((scalarValue - hangulStart) / 588)
            return initialConsonants[min(index, initialConsonants.count - 1)]
        }

        return nil
    }
}
