//
//  DraggableListFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct NearMeFirebaseStore: TKFirebaseStore {
    let viewID: String = "NM"
    
    enum FirebaseAction: String, FirebaseActionable {
        case nearMeItem
        case unRegistered
    }
    
    public func detailUserAction(
        _ userActionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        let event = FirebaseAction.create(eventName)
        
//        switch {
//
//        }
    }
    
}
