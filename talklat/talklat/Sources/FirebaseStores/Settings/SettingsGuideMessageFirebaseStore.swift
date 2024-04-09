//
//  SettingsGuideMessageFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsGuideMessageFirebaseStore: TKFirebaseStore {
    var viewID: String = "SG"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case toggle
        case editGuideMessage
        case unRegistered
    }
}
