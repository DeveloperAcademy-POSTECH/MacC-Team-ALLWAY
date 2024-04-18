//
//  HistoryInfoFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct HistoryInfoFirebaseStore: TKFirebaseStore {
    var viewId: String = "HI"
    
    func detailUserAction(_ actionType: UserActionType, _ eventName: String, _ payload: [String : Any]?) {
        
    }
    
    enum FirebaseAction: String, FirebaseActionable {
        case back
        case STTBubble
        case WTTBubble
        case unRegistered
    }
}
