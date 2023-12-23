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
    
    static func getHistoryItemArray() -> [HistoryItem] {
        [
            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
            .init(id: .init(), text: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
            .init(id: .init(), text: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
            .init(id: .init(), text: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
            .init(id: .init(), text: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
        ]
    }
}
