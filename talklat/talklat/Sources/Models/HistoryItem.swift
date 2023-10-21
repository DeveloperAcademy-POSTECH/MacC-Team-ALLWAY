//
//  HistoryItem.swift
//  talklat
//
//  Created by 신정연 on 2023/10/20.
//

import Foundation

struct HistoryItem: Identifiable {
    var id: UUID
    enum MessageType {
        case question, answer
    }
    let text: String
    let type: MessageType
}
