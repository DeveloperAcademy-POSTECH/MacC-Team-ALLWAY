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
    
    var replacements: [TKTextReplacement] = []
    
    // MARK: 기본 Create
    public func createTextReplacement(textReplacement: TKTextReplacement) {
        context.insert(textReplacement)
        try? context.save()
    }
    
    // MARK: 텍대 데이터 구조 변형 시 Create
//    func addTextReplacement(phrase: String, replacement: String) {
//        if let existingReplacement = replacements.first(where: { $0.wordDictionary.keys.contains(phrase) }) {
//            existingReplacement.wordDictionary[phrase]?.append(replacement)
//            try? context.save()
//        } else {
//            let newReplacement = TKTextReplacement(wordDictionary: [phrase: [replacement]])
//            replacements.append(newReplacement)
//            context.insert(newReplacement)
//            try? context.save()
//        }
//    }

    public func findReplacement(for inputText: String) -> [String]? {
        return replacements.first(where: { $0.wordDictionary.keys.contains(inputText) })?.wordDictionary[inputText]
    }

    // TODO: UI작업과 같이 할 것
    public func updateTextReplacement(
        phrase: TKTextReplacement,
        replacement: TKTextReplacement
    ) {
        
    }
    
    public func deleteTextReplacement(textReplacement: TKTextReplacement) {
        context.delete(textReplacement)
    }
    
    // MARK: 리스트에서 특정 키에 해당하는 값을 찾는 메서드
//    func findValueForKeyInLists(key: String, lists: [TKTextReplacement]) -> String? {
//        return lists.first(where: { $0.wordDictionary[key] != nil })?.wordDictionary[key]
//    }

}

