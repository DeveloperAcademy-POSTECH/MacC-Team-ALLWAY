//
//  ConversationTypingFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationTypingFirebaseStore: TKFirebaseStore {
    let viewId: String = "CT"
    
    enum FirebaseAction: String, FirebaseActionable {
        static let cancel = "cancel"
//        case cancel
        case save
        case field
        case eraseAll
        case next
        case unRegistered
    }
}


