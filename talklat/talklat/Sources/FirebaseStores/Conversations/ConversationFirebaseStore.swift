//
//  ConversationViewFireStore.swift
//  bisdam
//
//  Created by user on 4/8/24.
//

import Foundation

struct ConversationFirebaseStore: TKFirebaseStore {
    internal var viewId: String = "C"
    
    enum FirebaseAction: String, FirebaseActionable {
        case cancel
        case save
        case field
        case eraseAll
        case next
        case textReplace
        case unRegistered
    }
    
    public func detailUserAction(
        _ userActionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        let event = FirebaseAction.create(eventName)
        
//        switch event {
//            
//        }
    }
    
    private func changeViewID() {
        
    }
}
