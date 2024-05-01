//
//  HistoryFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct HistoryFirebaseStore: TKFirebaseStore {
    var viewId: String = "H"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case edit
        case field
        case discloseSection
        case item
        case complete
        case select
        case delete
        case alertCancel
        case alertDelete
        case unRegistered
    }
}
