//
//  talklatApp.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

@main
struct talklatApp: App {
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .authCompleted:
                    HandlingTestingView()
                case .speechRecognitionAuthIncompleted,
                        .microphoneAuthIncompleted,
                        .authIncompleted:
                    AuthorizationRequestView(
                        currentRoot: appRootManager.currentRoot
                    )
                }
            }
            .environmentObject(appRootManager)
            .task {
                await appRootManager.switchAuthorizationStatus()
            }
        }
    }
}
