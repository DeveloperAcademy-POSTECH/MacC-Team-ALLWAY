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
    @StateObject private var settingStore = SettingViewStore(settingState: .init())
    @StateObject private var store: TKMainViewStore = TKMainViewStore()
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
                switch store(\.authStatus) {
                case .splash:
                    TKSplashView()
                        .task {
                            try? await Task.sleep(for: .seconds(3.0))
                            let status = await SpeechAuthManager.switchAuthStatus()
                            store.onVoiceAuthorizationObtained(status)
                        }

                default:
                    NavigationStack {
                        TKMainView(store: store)
                    }
                    .transition(.opacity.animation(.easeInOut))
                }
            }
            .onChange(of: scenePhase) { _, _ in
                Color.colorScheme = UITraitCollection.current.userInterfaceStyle
            }
        }
        .modelContainer(container)
        .environmentObject(settingStore)

    }
}
