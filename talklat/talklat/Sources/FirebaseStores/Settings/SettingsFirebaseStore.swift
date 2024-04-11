//
//  SettingsFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsFirebaseStore: TKFirebaseStore {
    var viewId: String = "S"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case textReplacement
        case guideMessage
        case displayMode
        case personalInfo
        case makers
        case help
        case speechPermit
        case locationPermit
        case unRegistered
    }
}
