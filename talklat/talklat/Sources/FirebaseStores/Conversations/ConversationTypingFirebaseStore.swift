//
//  ConversationTypingFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationTypingFirebaseStore: TKFirebaseStore {
    let viewID: String = "CT"
    
    enum FirebaseAction: String, FirebaseActionable {
        static let cancel = "cancel"
//        case cancel
        case save
        case field
        case eraseAll
        case next
        case unRegistered
    }
    
    func detailUserAction(
        _ userActionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        let event = FirebaseAction.create(eventName)
    }
}


