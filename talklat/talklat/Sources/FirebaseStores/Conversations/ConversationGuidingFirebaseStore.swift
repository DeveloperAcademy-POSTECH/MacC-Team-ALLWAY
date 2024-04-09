//
//  ConversationGuidingFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct ConversationGuidingFirebaseStore: TKFirebaseStore {
    let viewID: String = "CG"
    
    enum FirebaseAction: String,  FirebaseActionable {
        case back
        case unRegistered
    }
}
