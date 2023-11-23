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
    var createdAt: Date
    var conversation: TKConversation?
    private var status: MessageType.RawValue
    
    var type: MessageType {
        get {
            return MessageType(rawValue: self.status)!
        }
        
        set {
            self.status = newValue.rawValue
        }
    }
    
    init(
        text: String,
        type: MessageType,
        createdAt: Date
    ) {
        self.text = text
        self.createdAt = createdAt
        self.status = type.rawValue
    }
}
