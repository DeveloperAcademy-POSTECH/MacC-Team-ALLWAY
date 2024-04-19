//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import MapKit
import SwiftUI

struct TKMainView: View, FirebaseAnalyzable {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    
    @EnvironmentObject private var locationStore: TKLocationStore
    @EnvironmentObject private var authManager: TKAuthManager
    
    @StateObject private var store: TKMainViewStore = TKMainViewStore()
    @StateObject private var conversationViewStore = TKConversationViewStore()
    
    @State private var recentConversation: TKConversation?
    
    let firebaseStore: any TKFirebaseStore = MainViewFirebaseStore()
    let permitAlertFirebaseStore: any TKFirebaseStore = PermitAlertFirebaseStore()
    
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
                          
                            BDText(
                              text:
                                locationStore(\.mainPlaceName),
                              style: .H1_B_130
                            )
                        }
                    }
                    .foregroundStyle(Color.GR4)

                    BDText(text: NSLocalizedString("새 대화 시작하기", comment: ""), style: .T2_B_125)
                        .foregroundStyle(Color.OR5)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
          
            Spacer()
                .frame(maxHeight: 50)
            
            TKOrbitCircles(
              store: store,
              circleRenderInfos: [
                CircleRenderInfo(x: -24, y: -8),
                CircleRenderInfo(x: -16, y: 24),
                CircleRenderInfo(x: 14, y: -8),
              ],
              circleColor: Color.OR5
            )
            .task { store.triggerAnimation(true) }
            .frame(width: 200, height: 200)
            .overlay {
              startConversationButtonBuilder()
            }
            
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
            firebaseStore.userDidAction(.viewed)
        }
        .fullScreenCover(isPresented: store[\.isConversationFullScreenCoverDisplayed]) {
            TKConversationView(store: conversationViewStore)
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
                    style: .conversationCancellation,
                    onDismiss:
                        {
                            switch conversationViewStore(\.conversationStatus) {
                            case .recording:
                                firebaseStore.userDidAction(.tapped(.alertBack("CL")))
                            case .guiding:
                                firebaseStore.userDidAction(.tapped(.alertBack("CG")))
                            case .writing:
                                firebaseStore.userDidAction(.tapped(.alertBack("CT")))
                            }
                        }
                ) {
                    switch conversationViewStore(\.conversationStatus) {
                    case .recording:
                        firebaseStore.userDidAction(.tapped(.alertCancel("CL")))
                    case .guiding:
                        firebaseStore.userDidAction(.tapped(.alertCancel("CG")))
                    case .writing:
                        firebaseStore.userDidAction(.tapped(.alertCancel("CT")))
                    }
                    store.onConversationFullscreenDismissed()
                } confirmButtonLabel: {
                    BDText(text: NSLocalizedString("네, 그만 할래요", comment: ""), style: .H2_SB_135)
                }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(colorScheme == .light ? "bisdam_typo" : "bisdam_typo_Dark")
                    .resizable()
                    .localizeLogoFrame()
                    .padding(.leading, 8)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    #warning("MEMORY LEAKS IN TKCONVERSATION/TKCONTENT")
                    HistoryListView()
                } label: {
                    Image(colorScheme == .light ? "history_symbol_light" : "history_symbol_dark")
                        .resizable()
                }
                .tint(Color.GR3)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded{ _ in
                            firebaseStore.userDidAction(.tapped(.history))
                        }
                )
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsListView()
                    
                } label: {
                    Image(colorScheme == .light ? "settings_symbol_light" : "settings_symbol_dark")
                        .resizable()
                }
                .tint(Color.GR3)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            firebaseStore.userDidAction(.tapped(.setting))
                        }
                )
            }
        }
        .background { Color.GR1.ignoresSafeArea(edges: [.top, .bottom]) }
        .showTKAlert(
            isPresented: store[\.isSpeechAuthAlertPresented],
            style: .conversation,
            onDismiss: {
                permitAlertFirebaseStore.userDidAction(.tapped(.back))
            }
        ) {
            permitAlertFirebaseStore.userDidAction(.tapped(.permit))
            store.onGoSettingScreenButtonTapped()
        } confirmButtonLabel: {
            HStack(spacing: 8) {
                BDText(text: NSLocalizedString("설정으로 이동", comment: ""), style: .H2_SB_135)
                
                Image(systemName: "arrow.up.right.square.fill")
            }
            .onAppear {
                permitAlertFirebaseStore.userDidAction(.viewed)
            }
        }
        .overlay(alignment: .top) {
            if let recent = recentConversation,
               let location = recent.location,
               store(\.isTKToastPresented) {
                TKToast(
                    isPresented: store[\.isTKToastPresented],
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
            firebaseStore.userDidAction(.tapped(.newConversation))
        } label: {
            ZStack {
                Circle()
                    .fill(Color.OR6)
                    .frame(width: 200, height: 200)
                    .opacity(0.5)
              
                Circle()
                    .fill(Color.OR6)
                    .frame(width: 120, height: 120)
                    .opacity(0.3)
              
                Circle()
                    .fill(Color.OR6)
                    .frame(width: 100, height: 100)
                
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

#Preview("EN") {
    NavigationStack {
        TKMainView()
            .environment(\.locale, Locale(identifier: "en"))
            .environment(TKSwiftDataStore())
            .environmentObject(TKLocationStore())
            .environmentObject(TKAuthManager())
    }
}

#Preview("KR") {
    NavigationStack {
        TKMainView()
            .environment(\.locale, .init(identifier: "ko"))
            .environment(TKSwiftDataStore())
            .environmentObject(TKLocationStore())
            .environmentObject(TKAuthManager())
    }
}
