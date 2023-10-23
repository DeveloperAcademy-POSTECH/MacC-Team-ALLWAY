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
    
    @State private var animateFlagA: Bool = false
    @State private var animateFlagB: Bool = false
    @State private var isInitCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appViewStore.currentAuthStatus {
                case .splash:
                    Temp_SplashView(animateFlag: $animateFlagA)
                        .task {
                            animateFlagA = true
                            try? await Task.sleep(for: .seconds(1.5))
                            
                            let status = await appRootManager.switchAuthStatus()
                            // TODO: Transition
                            appViewStore.voiceRecordingAuthSetter(status)
                        }
                    
                case .authCompleted:
                    NavigationStack {
                        TKIntroView(appViewStore: appViewStore)
                    }
                    
                case .speechRecognitionAuthIncompleted
                    ,.microphoneAuthIncompleted
                    ,.authIncompleted:
                    AuthorizationRequestView(currentAuthStatus: appViewStore.currentAuthStatus)
                }
            }
            .onAppear {
                appViewStore.voiceRecordingAuthSetter(.splash)
            }
        }
    }
}

struct Temp_SplashView: View {
    @Binding var animateFlag: Bool
    
    var body: some View {
        Image("TalklatLogo")
            .scaleEffect(animateFlag ? 0.3 : 0.25)
            .opacity(animateFlag ? 1.0 : 0.6)
            .animation(
                .easeInOut.speed(0.35),
                value: animateFlag
            )
            .frame(width: 280, height: 100)
    }
}
