//
//  ConversationSaveFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationSaveFirebaseStore: TKFirebaseStore {
    var viewID: String = "CS"
    
    enum FirebaseAction: String, FirebaseActionable {
        case handle
        case cancel
        case save
        case field
        case eraseAll
        case unRegistered
    }
    
    func detailUserAction(
        _ actionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        
    }
}
