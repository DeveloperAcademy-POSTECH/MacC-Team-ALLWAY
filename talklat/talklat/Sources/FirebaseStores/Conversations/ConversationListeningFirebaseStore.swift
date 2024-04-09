//
//  ConversationListeningFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationListeningFirebaseStore: TKFirebaseStore {
    let viewID: String = "CL"
    
    enum FirebaseAction: String, FirebaseActionable {
        case viewed
        case back
        case next
        case cancel
        case save
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
