//
//  ConversationRepeatFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationRepeatFirebaseStore: TKFirebaseStore {
    var viewId: String = "CR"
    
    
    enum FirebaseAction: String, FirebaseActionable {
        case cancel
        case goToPreView
        case save
        case STTField
        case WTTField
        case next
        case eraseAll
        case textReplace
        case alertBack
        case alertCancel
        case unRegistered
    }
}
