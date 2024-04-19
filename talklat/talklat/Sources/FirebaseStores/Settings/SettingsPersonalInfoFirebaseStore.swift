//
//  SettingsPersonalInfoFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsPersonalInfoFirebaseStore: TKFirebaseStore {
    var viewId: String = "SP"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case unRegistered
    }
}
