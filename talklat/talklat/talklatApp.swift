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
    @StateObject private var locationStore: TKLocationStore = TKLocationStore()
    @StateObject private var authManager: TKAuthManager = TKAuthManager()
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
                if case .splash = authManager.authStatus {
                    TKSplashView()
                        .task {
                            try? await Task.sleep(for: .seconds(3.0))
                            authManager.checkOnboardingCompletion()
                        }
                }
                
                if case .onboarding = authManager.authStatus {
                    TKOnboardingView(authManager: authManager)
                        .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                }
                
                if case .requestAuthComplete = authManager.authStatus {
                    NavigationStack {
                        TKMainView(authManager: authManager)
                            .onAppear {
                                locationStore.onMainViewAppear()
                            }
                    }
                    .transition(.opacity.animation(.easeInOut))
                }
            }
            .environmentObject(locationStore)
            .onChange(of: scenePhase) { _, _ in
                Color.colorScheme = UITraitCollection.current.userInterfaceStyle
            }
        }
        .modelContainer(container)
    }
}
