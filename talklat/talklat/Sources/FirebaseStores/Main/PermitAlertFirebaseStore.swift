//
//  PermitAlertFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation
import SwiftUI

struct PermitAlertFirebaseStore: TKFirebaseStore {
    let viewId: String = "PA"
    
    enum FirebaseAction: String, FirebaseActionable {
        case permit
        case back
        case unRegistered
    }
    
    
    func detailUserAction(
        _ userActionType: UserActionType,
        _ eventName: String,
        _ payload: [String : Any]?
    ) {
        let event = FirebaseAction.create(eventName)
    }
}
