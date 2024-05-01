//
//  DraggableListFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct NearMeFirebaseStore: TKFirebaseStore {
    let viewId: String = "NM"
    
    enum FirebaseAction: String, FirebaseActionable {
        case nearMeItem
        case unRegistered
    }   
}
