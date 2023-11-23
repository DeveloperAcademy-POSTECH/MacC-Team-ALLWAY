//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import MapKit
import SwiftUI

struct TKMainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var locationStore: TKLocationStore
    @ObservedObject var store: TKMainViewStore
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
                            
                            Text("\(locationStore(\.mainPlaceName))")
                        }
                    }
                    .foregroundStyle(Color.GR4)

                    
                    Text("새 대화 시작하기")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.OR5)
                }
                .padding(.bottom, 50)

                TKOrbitCircles(
                    store: store,
                    circleRenderInfos: [
                        CircleRenderInfo(x: -25, y: -15),
                        CircleRenderInfo(x: 0, y: 27),
                        CircleRenderInfo(x: 25, y: -15),
                    ],
                    circleColor: Color.OR6
                )
                .frame(maxHeight: 200)
                .overlay {
                    Circle()
                        .fill(Color.OR6)
                        .opacity(0.5)
                        .frame(width: 200, height: 200)
                }
                .overlay {
                    startConversationButtonBuilder()
                }
            }
            .frame(
                maxHeight: .infinity,
                alignment: .top
            )
            
//            // MARK: BottomSheet
            TKDraggableList(store: store)
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
        }
        .environmentObject(locationStore)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image("bisdam_typo")
                    .resizable()
                    .frame(width: 56.15, height: 23.48)
                    .foregroundStyle(Color.OR5)
                    .padding(.leading, 8)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    HistoryListView()
                    
                } label: {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .foregroundStyle(Color.GR3)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsListView()
                    
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.GR3)
                }
            }
        }
        .background { Color.GR1.ignoresSafeArea(edges: [.top, .bottom]) }
        .overlay {
            TKAlert(
                style: .mic,
                isPresented: store.bindingSpeechAuthAlert()
            ) {
                store.onGoSettingScreenButtonTapped()
                
            } actionButtonLabel: {
                HStack(spacing: 8) {
                    Text("설정으로 이동")
                    
                    Image(systemName: "arrow.up.right.square.fill")
                }
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
        .environmentObject(locationStore)
    }
    
    private func startConversationButtonBuilder() -> some View {
        Button {
            if store(\.authStatus) != .authCompleted {
                store.onStartConversationButtonTappedWithoutAuth()
            } else {
                store.onStartConversationButtonTapped()
            }
            
        } label: {
            ZStack {
                Circle()
                    .fill(Color.OR6)
                    .opacity(0.3)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.OR6)
                    .frame(width: 100, height: 100)
                
                Image("TALKLAT_BUBBLE_WHITE")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .frame(width: 59, height: 70)
                    .padding(.top, 12)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .bold()
                    .foregroundStyle(Color.OR6)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TKMainView(store: TKMainViewStore())
            .environmentObject(TKLocationStore())
    }
}
