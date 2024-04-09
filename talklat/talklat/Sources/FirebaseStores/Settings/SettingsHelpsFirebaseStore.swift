//
//  SettingsHelpsFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsHelpsFirebaseStore: TKFirebaseStore {
    var viewID: String = "SH"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case mail
        case unRegistered
    }
}
