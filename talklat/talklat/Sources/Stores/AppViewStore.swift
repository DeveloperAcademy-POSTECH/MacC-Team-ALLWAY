//
//  AppViewManager.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

final class AppViewStore: ObservableObject {
    enum CommunicationStatus: String {
        case recording
        case writing
    }
    
    @Published var communicationStatus: CommunicationStatus = .writing
    @Published var questionText: String = ""
}
