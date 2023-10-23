//
//  talklatApp.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

@main
struct talklatApp: App {
    @StateObject private var appViewStore: AppViewStore = AppViewStore(
        communicationStatus: .writing,
        questionText: "",
        currentAuthStatus: .authIncompleted
    )
    
    private let appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appViewStore.currentAuthStatus {
                case .authCompleted:
                    NavigationStack {
                        ScrollContainer(appViewStore: appViewStore)
                    }
                    
                case .speechRecognitionAuthIncompleted
                    ,.microphoneAuthIncompleted
                    ,.authIncompleted:
                    AuthorizationRequestView(currentAuthStatus: appViewStore.currentAuthStatus)
                }
            }
            .task {
                // MARK: App Splash View에서 처리
                let status = await appRootManager.switchAuthStatus()
                appViewStore.voiceRecordingAuthSetter(status)
            }
        }
    }
}
