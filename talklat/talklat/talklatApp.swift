//
//  talklatApp.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Lottie
import SwiftUI
import SwiftData

@main
struct talklatApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var locationStore: TKLocationStore = TKLocationStore()
    @StateObject private var authManager: TKAuthManager = TKAuthManager()
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    
    @State private var swiftDataManager: TKSwiftDataStore = TKSwiftDataStore()
    @State private var lottiePlaybackMode: LottiePlaybackMode = LottiePlaybackMode.paused
    
    var body: some Scene {
        WindowGroup {
            Group {
                if case .splash = authManager.authStatus {
                    TKSplashView(playbackMode: $lottiePlaybackMode)
                        .transition(.opacity.animation(.easeInOut))
                        .onChange(of: lottiePlaybackMode) { _, newValue in
                            if newValue == .paused {
                                Task { try? await Task.sleep(for: .seconds(0.3)) }
                                authManager.checkOnboardingCompletion()
                            }
                        }
                }
                
                if case .onboarding = authManager.authStatus {
                    TKOnboardingView(authManager: authManager)
                        .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                }
                
                if case .requestAuthComplete = authManager.authStatus {
                    NavigationStack {
                        TKMainView()
                            .onAppear {
                                locationStore.onMainViewAppear()
                            }
                    }
                    .transition(.opacity.animation(.easeInOut))
                }
            }
            .environmentObject(locationStore)
            .environmentObject(authManager)
            .environmentObject(colorSchemeManager)
            .environment(swiftDataManager)
            .onAppear {
                // ColorScheme UserDefault
                UserDefaults.standard.setValue(
                    false,
                    forKey: "_UIConstraintBasedLayoutLogUnsatisfiable"
                )
                colorSchemeManager.applyColorScheme()
                
                // GuideMessage UserDefault
                if !isKeyPresentInUserDefaults(key: "isGuidingEnabled") {
                    UserDefaults.standard.setValue(
                        true,
                        forKey: "isGuidingEnabled"
                    )
                }
            }
        }
    }
}
