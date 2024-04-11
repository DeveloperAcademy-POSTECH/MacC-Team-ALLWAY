//
//  SettingsTextReplacementAddFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsTextReplacementAddFirebaseStore: TKFirebaseStore {
    var viewId: String = "STA"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case handle
        case cancel
        case shortenTextField
        case fullTextField
        case complete
        case unRegistered
    }
}
