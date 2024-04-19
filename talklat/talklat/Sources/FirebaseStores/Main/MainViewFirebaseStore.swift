//
//  MainViewFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/6/24.
//

import Foundation

struct MainViewFirebaseStore: TKFirebaseStore {
    let viewId: String = "M"
    
    public enum FirebaseAction: String, FirebaseActionable {
        case history
        case setting
        case newConversation
        case unRegistered
    }
}

