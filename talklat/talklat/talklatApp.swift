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
    @StateObject private var store: TKMainViewStore = TKMainViewStore()
    @StateObject private var locationStore: TKLocationStore = TKLocationStore()
    @StateObject private var authManager: TKAuthManager = TKAuthManager()
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    
    private var container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TKTextReplacement.self)
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
            .environmentObject(locationStore)
            .environmentObject(authManager)
            .environmentObject(colorSchemeManager)
            .onAppear {
                UserDefaults.standard.setValue(
                    false,
                    forKey: "_UIConstraintBasedLayoutLogUnsatisfiable"
                )
                colorSchemeManager.applyColorScheme()
            }
        }
        .modelContainer(container)
    }
}
