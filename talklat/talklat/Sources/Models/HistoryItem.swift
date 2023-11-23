//
//  HistoryItem.swift
//  talklat
//
//  Created by 신정연 on 2023/10/20.
//

import Foundation

struct HistoryItem: Identifiable, Equatable {
    enum MessageType {
        case question, answer
    }
    
    var id: UUID
    let text: String
    let type: MessageType
    let createdAt: Date
}
