//
//  HistoryInfoEditLocationFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct HistoryInfoEditLocationFirebaseStore: TKFirebaseStore {
    var viewID: String = "HIEL"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case handle
        case close
        case map
        case myLocation
        case pointPin
        case unRegistered
    }
}
