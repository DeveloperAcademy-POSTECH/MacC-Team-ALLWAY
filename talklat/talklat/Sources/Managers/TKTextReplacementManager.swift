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
    
    func addTextReplacement(phrase: String, replacement: String) {
        if let existingReplacement = replacements.first(where: { $0.wordDictionary.keys.contains(phrase) }) {
            existingReplacement.wordDictionary[phrase]?.append(replacement)
            try? context.save()
        } else {
            let newReplacement = TKTextReplacement(wordDictionary: [phrase: [replacement]])
            replacements.append(newReplacement)
            context.insert(newReplacement)
            try? context.save()
        }
    }

    public func findReplacement(for inputText: String) -> [String]? {
        return replacements.first(where: { $0.wordDictionary.keys.contains(inputText) })?.wordDictionary[inputText]
    }

    public func createTextReplacement(textReplacement: TKTextReplacement) {
        context.insert(textReplacement)
        // 필요하다면 여기에서 context.save()를 호출하여 변경 사항을 저장할 수 있습니다.
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

