//
//  MainViewFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/6/24.
//

import Foundation

struct MainViewFirebaseStore: TKFirebaseStore {
    let viewID: String = "M"
    
    public enum FirebaseAction: String, FirebaseActionable {
        case history
        case setting
        case newConversation
        case unRegistered
    }
    
    
//    public func detailUserAction(
//        _ userActionType: UserActionType,
//        _ eventName: String,
//        _ payload: [String : Any]?
//    ) {
//        let userActionType = userActionType.rawValue
//        let event = FirebaseAction.create(eventName)
//        
//        
//        switch event {
//            
//        case .history:
//            break
//        case .setting:
//            break
//        case .newConversation:
//            break
//        case .unRegistered:
//            print("This event")
//        }
//    }
}

