//
//  ConversationRepeatFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationRepeatFirebaseStore: TKFirebaseStore {
    var viewID: String = "CR"
    
    func detailUserAction(
        _ actionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        
    }
    
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
