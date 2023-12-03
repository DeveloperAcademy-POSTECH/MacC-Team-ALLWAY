//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import Lottie
import MapKit
import SwiftUI

struct TKMainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var locationStore: TKLocationStore
    @EnvironmentObject private var authManager: TKAuthManager
    
    @StateObject private var store: TKMainViewStore = TKMainViewStore()
    @StateObject private var conversationViewStore = TKConversationViewStore()
    
    @State private var recentConversation: TKConversation?
    let swiftDataStore = TKSwiftDataStore()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: 120)
                
                VStack(spacing: 10) {
                    HStack(spacing: 2) {
                        if let status = locationStore(\.authorizationStatus) {
                            switch status {
                            case .authorizedAlways, .authorizedWhenInUse:
                                Image(systemName: "location.fill")
                                
                            default:
                                Image(systemName: "location.slash.fill")
                            }
                            BDText(text: "\(locationStore(\.mainPlaceName))", style: .H1_B_130)
                        }
                    }
                    .foregroundStyle(Color.GR4)

                    BDText(text: "새 대화 시작하기", style: .T2_B_125)
                        .foregroundStyle(Color.OR5)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            
            LottieView(animation: .named("BDMain_Circle"))
                .playing(loopMode: .loop)
                .aspectRatio(0.4, contentMode: .fit)
                .overlay {
                    Circle()
                        .fill(Color.OR6)
                        .opacity(0.5)
                        .scaleEffect(0.65)
                }
                .overlay {
                    startConversationButtonBuilder()
                }
                .position(
                    x: UIScreen.main.bounds.width * 0.5,
                    y: UIScreen.main.bounds.height * 0.4
                )
            
            // MARK: BottomSheet
            if store(\.isTKMainViewAppeared) {
                TKDraggableList(
                    mainViewstore: store,
                    conversationViewStore: conversationViewStore
                )
                .transition(.move(edge: .bottom))
            }
        }
        .task {
           await store.onTKMainViewAppeared()
        }
        .fullScreenCover(isPresented: store.bindingConversationFullScreenCover()) {
            TKConversationView(store: conversationViewStore)
                .onDisappear {
                    conversationViewStore.resetConversationState()
                }
                .onChange(of: conversationViewStore(\.isConversationFullScreenDismissed)) { old, new in
                    if !old, new {
                        store.onConversationFullscreenDismissed()
                    }
                }
                .onChange(of: conversationViewStore(\.isNewConversationSaved)) { _, isSaved in
                    if isSaved {
                        self.recentConversation = swiftDataStore.getRecentConversation()
                        store.onNewConversationHasSaved()
                    }
                }
                .showTKAlert(
                    isPresented: conversationViewStore.bindingTKAlertFlag(),
                    style: .conversationCancellation
                ) {
                    store.onConversationFullscreenDismissed()
                    
                } confirmButtonLabel: {
                    BDText(text: "네, 그만 할래요", style: .H2_SB_135)
                }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(colorScheme == .light ? "bisdam_typo" : "bisdam_typo_Dark")
                    .resizable()
                    .frame(width: 56.15, height: 23.48)
                    .padding(.leading, 8)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    HistoryListView()
                } label: {
                    Image(colorScheme == .light ? "history_symbol_light" : "history_symbol_dark")
                        .resizable()
                }
                .tint(Color.GR3)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsListView()
                    
                } label: {
                    Image(colorScheme == .light ? "settings_symbol_light" : "settings_symbol_dark")
                        .resizable()
                }
                .tint(Color.GR3)
            }
        }
        .background { Color.GR1.ignoresSafeArea(edges: [.top, .bottom]) }
        .showTKAlert(
            isPresented: store.bindingSpeechAuthAlert(),
            style: .conversation
        ) {
            store.onGoSettingScreenButtonTapped()
            
        } confirmButtonLabel: {
            HStack(spacing: 8) {
                BDText(text: "설정으로 이동", style: .H2_SB_135)
                
                Image(systemName: "arrow.up.right.square.fill")
            }
        }
        .overlay(alignment: .top) {
            if let recent = recentConversation,
               let location = recent.location,
               store(\.isTKToastPresented)
            {
                TKToast(
                    isPresented: store.bindingTKToast(),
                    title: recent.title,
                    locationInfo: location.blockName
                )
            }
        }
    }
    
    private func startConversationButtonBuilder() -> some View {
        Button {
            if let isMicrophoneAuthorized = authManager.isMicrophoneAuthorized,
               let isSpeechRecognitionAuthorized = authManager.isSpeechRecognitionAuthorized,
               !isMicrophoneAuthorized || !isSpeechRecognitionAuthorized {
                store.onStartConversationButtonTappedWithoutAuth()
                
            } else {
                store.onStartConversationButtonTapped()
            }
            
        } label: {
            ZStack {
                Circle()
                    .fill(Color.OR6)
                    .opacity(0.5)
                    .scaleEffect(0.42)
                
                Circle()
                    .fill(Color.OR6)
                    .scaleEffect(0.35)
                
                Image("TALKLAT_BUBBLE_WHITE")
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .padding(.top, 12)
                
                Image(systemName: "plus")
                    .scaleEffect(1.2)
                    .bold()
                    .foregroundStyle(Color.OR6)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TKMainView()
            .environmentObject(TKLocationStore())
            .environmentObject(TKAuthManager())
    }
}
