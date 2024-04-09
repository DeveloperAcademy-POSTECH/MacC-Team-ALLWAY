//
//  SettingsHelpMailFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsHelpMailFirebaseStore: TKFirebaseStore {
    var viewID: String = "SHM"
    
    func detailUserAction(
        _ actionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case cancel
        case send
        case unRegistered
    }
}
