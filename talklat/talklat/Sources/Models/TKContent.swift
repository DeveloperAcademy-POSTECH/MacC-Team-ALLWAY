//
//  TKContent.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/11/23.
//

import Foundation
import SwiftData

@Model
final class TKContent {
    var text: String
    var status: MessageType.RawValue
    var createdAt: Date
    var conversation: TKConversation?
    
    init(
        text: String,
        status: MessageType.RawValue,
        createdAt: Date
    ) {
        self.text = text
        self.status = status
        self.createdAt = createdAt
    }
}


