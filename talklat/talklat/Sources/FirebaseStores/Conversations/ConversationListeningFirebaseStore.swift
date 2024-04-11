//
//  ConversationListeningFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationListeningFirebaseStore: TKFirebaseStore {
    let viewId: String = "CL"
    
    enum FirebaseAction: String, FirebaseActionable {
        case viewed
        case back
        case next
        case cancel
        case save
        case unRegistered
    }
}
