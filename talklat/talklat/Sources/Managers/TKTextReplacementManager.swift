//
//  TKTextReplacementManager.swift
//  talklat
//
//  Created by 신정연 on 11/8/23.
//

import Foundation
import SwiftData
import SwiftUI

// 아래 매니저 현재는 사용하지 않고, 뷰에서 바로 접근해서 CRU(D) 하고 있습니다.
class TKTextReplacementManager {
    @Environment(\.modelContext) private var context

    public func createTextReplacement(textReplacement: TKTextReplacement) {
        context.insert(textReplacement)
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
    func findValueForKeyInLists(key: String, lists: [TKTextReplacement]) -> String? {
        return lists.first(where: { $0.wordDictionary[key] != nil })?.wordDictionary[key]
    }

}

