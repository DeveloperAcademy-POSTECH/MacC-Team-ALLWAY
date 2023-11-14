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
    var replacementDict: [String: String]
    // var createdAt: Date // 들어갈지 안들어갈지는 추후에 결정
    
    init(replacementDict: [String : String]) {
        self.replacementDict = replacementDict
    }
}
