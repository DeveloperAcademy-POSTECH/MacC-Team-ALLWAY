//
//  TKTextReplacement.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//

import Foundation
import SwiftData

@Model
class TKTextReplacement {
    var wordDictionary: [String: String] = ["key": "value"]
    // var createdAt: Date // 들어갈지 안들어갈지는 추후에 결정
    
    init(
        wordDictionary: [String : String]
    ) {
        self.wordDictionary = wordDictionary
    }
}
