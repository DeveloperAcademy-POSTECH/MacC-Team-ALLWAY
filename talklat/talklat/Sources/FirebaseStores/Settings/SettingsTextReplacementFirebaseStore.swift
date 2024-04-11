//
//  SettingsTextReplacementFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsTextReplacementFirebaseStore: TKFirebaseStore {
    var viewId: String = "ST"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case add
        case field
        case item
        case indexBar
        case cancel
        case eraseAll
        case unRegistered
    }
}
