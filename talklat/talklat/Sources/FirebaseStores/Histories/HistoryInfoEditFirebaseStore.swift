//
//  HistoryInfoEditFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct HistoryInfoEditFirebaseStore: TKFirebaseStore {
    var viewId: String = "HIE"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case field
        case adjustLocation
        case save
        case alertBack
        case alertCancel
        case unRegistered
    }
}
