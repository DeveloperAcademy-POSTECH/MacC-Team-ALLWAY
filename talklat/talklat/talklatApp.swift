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
    @StateObject private var appRootManager = AppRootManager()

    let signalExtractor = SignalExtractor()

    var body: some Scene {
        WindowGroup {
            SignalExtractionView()
                .environmentObject(signalExtractor)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                Task(priority: .userInitiated) {
                    try? await signalExtractor.loadAudioSamples()
                    try? SignalGenerator(signalProvider: signalExtractor).start()
                }
            }
        }
    }
}
