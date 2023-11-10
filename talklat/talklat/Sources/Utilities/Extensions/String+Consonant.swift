//
//  String+Consonant.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import Foundation
import SwiftUI

extension String {
    // 한글 첫 자음과 영문 대문자에 대한 헤더 반환
    var headerKey: String {
        guard let firstChar = self.first else { return "#" }
        
        // 한글 첫 자음 또는 영문 대문자 체크
        return firstChar.headerKey
    }
}

extension Character {
    // 한글 첫 자음과 영문 대문자에 대한 헤더 반환
    var headerKey: String {
        if let koreanHeader = self.koreanFirstConsonant {
            return koreanHeader
        } else if self.isLetter && self.isUppercase {
            return String(self)
        }
        return "#"
    }
    
    // 한글 첫 자음 추출 (쌍자음 포함)
    var koreanFirstConsonant: String? {
        let hangulStart: UInt32 = 0xAC00 // '가' 값
        // 쌍자음 포함한 초기 자음 배열
        let initialConsonants = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        
        guard let scalarValue = UnicodeScalar(String(self))?.value else { return nil }
        
        print("Character: \(self), Scalar Value: \(scalarValue)")
        
        // 한글 범위 내에 있는지 확인
        if scalarValue >= hangulStart, scalarValue <= 0xD7A3 {
            let index = Int((scalarValue - hangulStart) / 588)
            print("Index: \(index), Consonant: \(initialConsonants[min(index, initialConsonants.count - 1)])")
            return initialConsonants[min(index, initialConsonants.count - 1)]
        }
        return nil
    }
}
