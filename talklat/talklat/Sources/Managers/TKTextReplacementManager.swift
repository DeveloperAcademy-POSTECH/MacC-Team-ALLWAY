//
//  TKTextReplacementManager.swift
//  talklat
//
//  Created by 신정연 on 11/8/23.
//

import Foundation
import SwiftData
import SwiftUI

class TKTextReplacementManager {
    @Environment(\.modelContext) private var context
    
    var totalDict: [String: [String: [String]]] = [:]  // 예: ["ㄱ": ["가나다": ["가", "나", "다"]], ...]
    
    // 새 TKTextReplacement 객체를 추가하는 함수
    func addTextReplacement(phrase: String, replacement: String) {
        let firstLetter = String(phrase.prefix(1)).headerKey  // 첫 글자 추출
        let wordDictionary = [phrase: [replacement]]  // 단일 문자열 값을 배열로 변환
        
        if totalDict[firstLetter] == nil {
            totalDict[firstLetter] = [:]
        }
        
        // 기존 값이 있으면, 새 값(배열)을 추가하고, 없으면 새 배열을 할당
        totalDict[firstLetter]?.merge(wordDictionary) { old, new in
            var combined = old
            combined.append(contentsOf: new)
            return combined
        }
    }
    
    public func createTextReplacement(textReplacement: TKTextReplacement) {
        context.insert(textReplacement)
    }
    
    public func updateTextReplacement(
        phrase: TKTextReplacement,
        replacement: TKTextReplacement
    ) {
        
    }
    
    public func deleteTextReplacement(textReplacement: TKTextReplacement) {
        context.delete(textReplacement)
    }
}

