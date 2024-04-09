//
//  HistorySearchFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct HistorySearchFirebaseStore: TKFirebaseStore {
    var viewID: String = "HS"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case field
        case cancel
        case eraseAll
        case item
        case unRegistered
    }
}
