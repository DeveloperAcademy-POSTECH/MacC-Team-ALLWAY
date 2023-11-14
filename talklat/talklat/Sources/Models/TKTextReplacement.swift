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

    var wordDictionary: [String: [String]] = [:]
    
    init(
        wordDictionary: [String: [String]]
    ) {
        self.wordDictionary = wordDictionary
    }
}
