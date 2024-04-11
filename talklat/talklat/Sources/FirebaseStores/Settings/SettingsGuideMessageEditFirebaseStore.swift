//
//  SettingsGuideMessageEditFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsGuideMessageEditFirebaseStore: TKFirebaseStore {
    var viewId: String = "SGE"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case preview
        case guideMessageField
        case eraseAll
        case unRegistered
    }
}
