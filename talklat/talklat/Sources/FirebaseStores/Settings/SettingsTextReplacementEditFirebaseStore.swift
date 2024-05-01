//
//  SettingsTextReplacementEditFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/9/24.
//

import Foundation

struct SettingsTextReplacementEditFirebaseStore: TKFirebaseStore {
    var viewId: String = "STE"
    
    
    enum FirebaseAction: String, FirebaseActionable {
        case shortenTextField
        case fullTextField
        case delete
        case save
        case alertBack
        case alertDelete
        case unRegistered
    }
}
