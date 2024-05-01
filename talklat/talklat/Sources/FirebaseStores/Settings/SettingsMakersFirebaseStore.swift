//
//  SettingsMakersFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsMakersFirebaseStore: TKFirebaseStore {
    var viewId: String = "SM"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case unRegistered
    }
}
