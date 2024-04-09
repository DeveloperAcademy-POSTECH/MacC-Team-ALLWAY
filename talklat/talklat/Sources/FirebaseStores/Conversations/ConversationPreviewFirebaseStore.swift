//
//  ConversationPreviewFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationPreviewFirebaseStore: TKFirebaseStore {
    var viewID: String = "CP"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case goToTypingView
        case unRegistered
    }
}
