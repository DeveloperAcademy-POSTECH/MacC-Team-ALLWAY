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

    
    public func updateTextReplacement(
        phrase: TKTextReplacement,
        replacement: TKTextReplacement
    ) {
        
    }
    
    public func deleteTextReplacement(textReplacement: TKTextReplacement) {
        context.delete(textReplacement)
    }
}

