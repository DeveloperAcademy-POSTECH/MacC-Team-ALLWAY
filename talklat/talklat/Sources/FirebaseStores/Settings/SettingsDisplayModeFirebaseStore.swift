//
//  SettingsDisplayModeFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsDisplayModeFirebaseStore: TKFirebaseStore {
    var viewID: String = "SD"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case sameMode
        case lightMode
        case darkMode
        case unRegistered
    }
}

