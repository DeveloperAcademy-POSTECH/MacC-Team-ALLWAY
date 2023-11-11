//
//  talklatApp.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

@main
struct talklatApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appViewStore: AppViewStore = AppViewStore(
        communicationStatus: .writing,
        questionText: ""
    )
    
    @StateObject private var store: TKConversationViewStore = TKConversationViewStore()
    
    private let appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appViewStore.currentAuthStatus {
                case .splash:
                    Temp_SplashView()
                        .task {
                            try? await Task.sleep(for: .seconds(1.5))
                            let status = await appRootManager.switchAuthStatus()
                            appViewStore.voiceRecordingAuthSetter(status)
                        }
                    
                case .authCompleted:
                    TKConversationView(store: store)
                    
                case .speechRecognitionAuthIncompleted
                    ,.microphoneAuthIncompleted
                    ,.authIncompleted:
                    AuthorizationRequestView(currentAuthStatus: appViewStore.currentAuthStatus)
                }
            }
            .onAppear {
                appViewStore.voiceRecordingAuthSetter(.splash)
            }
            .onChange(of: scenePhase) { _, _ in
                Color.colorScheme = UITraitCollection.current.userInterfaceStyle
            }
        }
    }
}

struct Temp_SplashView: View {
    @State private var animateFlag: Bool = false
    
    var body: some View {
        Image("TalklatLogo")
            .scaleEffect(animateFlag ? 0.3 : 0.25)
            .opacity(animateFlag ? 1.0 : 0.6)
            .animation(
                .easeInOut.speed(0.35),
                value: animateFlag
            )
            .frame(width: 280, height: 100)
            .onAppear {
                animateFlag.toggle()
            }
    }
}
