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
                switch appRootManager.currentAuthStatus {
                case .authCompleted:
                    StaffSpeechView()
                case .speechRecognitionAuthIncompleted,
                        .microphoneAuthIncompleted,
                        .authIncompleted:
                    AuthorizationRequestView(
                        currentAuthStatus: appRootManager.currentAuthStatus
                    )
                }
            }
            .environmentObject(appRootManager)
            .task {
                await appRootManager.switchAuthStatus()
            }
        }
    }
}
