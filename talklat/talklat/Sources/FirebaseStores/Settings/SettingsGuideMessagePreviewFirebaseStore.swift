//
//  SettingsGuideMessagePreviewFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsGuideMessagePreviewFirebaseStore: TKFirebaseStore {
    var viewId: String = "SGEP"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case close
        case unRegistered
    }
}
