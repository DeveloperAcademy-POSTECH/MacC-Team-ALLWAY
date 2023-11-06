//
//  talklatApp.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI
import SwiftData

@main
struct talklatApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appViewStore: AppViewStore = AppViewStore(
        communicationStatus: .writing,
        questionText: ""
    )
    
    @StateObject private var store: ConversationViewStore = ConversationViewStore(
        conversationState: ConversationViewStore.ConversationState(
            conversationStatus: .writing
        )
    )
    
    private let appRootManager = AppRootManager()
    private var container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: TKConversation.self, TKTextReplacement.self
            )
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
        
        // DB 파일이 저장된 경로
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
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
                    ScrollContainer(store: store)
                    
                case .speechRecognitionAuthIncompleted
                    ,.microphoneAuthIncompleted
                    ,.authIncompleted:
                    AuthorizationRequestView(currentAuthStatus: appViewStore.currentAuthStatus)
                }
            }
            .onAppear {
                appViewStore.voiceRecordingAuthSetter(.splash)
            }
            .onChange(of: scenePhase) { _ in
                Color.colorScheme = UITraitCollection.current.userInterfaceStyle
            }
        }
        .modelContainer(container)
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
