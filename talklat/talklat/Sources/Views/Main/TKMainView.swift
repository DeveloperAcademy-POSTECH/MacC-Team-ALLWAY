//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKMainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var store: TKMainViewStore
    @StateObject private var conversationViewStore = TKConversationViewStore()
    @State private var flag: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: 120)
                
                VStack(spacing: 10) {
                    HStack(spacing: 2) {
                        Image(systemName: "location.fill")
                        
                        Text("현재 위치")
                            .font(.headline)
                            .bold()
                    }
                    .foregroundStyle(Color.gray400)
                    
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
            
            // MARK: BottomSheet
            TKDraggableList(store: store)
        }
        .fullScreenCover(isPresented: store.bindingConversationFullScreenCover()) {
            TKConversationView(store: conversationViewStore)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image("TALKLAT_TYPO")
                    .resizable()
                    .frame(width: 115, height: 20)
                    .foregroundStyle(Color.OR5)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("ALL HISTORY VIEW HERE")
                } label: {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .foregroundStyle(Color.gray300)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("SETTING VIEW HERE")
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.gray300)
                }
            }
        }
        .background { Color.gray100.ignoresSafeArea(edges: .top) }
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
            .onChange(of: scenePhase) { _, _ in
                Task { @MainActor in
                    let authResult = await SpeechAuthManager.switchAuthStatus()
                    store.onChangeOfSpeechAuth(authResult)
                }
            }
        }
        .overlay(alignment: .top) {
            TKToast(isPresented: conversationViewStore.bindingNewConversationToast())
        }
        .task {
            try? await Task.sleep(for: .seconds(3))
            conversationViewStore.onSaveNewConversationButtonTapped()
        }
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
    }
}
