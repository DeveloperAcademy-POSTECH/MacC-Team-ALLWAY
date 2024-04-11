//
//  TKListeningView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import Observation
import SwiftUI

struct TKListeningView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @Environment(TKSwiftDataStore.self) private var dataStore
    
    @ObservedObject var store: TKConversationViewStore
    let namespaceID: Namespace.ID
    let firebaseStore: any TKFirebaseStore = ConversationListeningFirebaseStore()
    
    var body: some View {
        VStack {
            HStack {
                if store(\.answeredText).isEmpty {
                    Button {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "back",
//                            nil
//                        )
                        firebaseStore.userDidAction(.tapped(.back))
                        store.blockButtonDoubleTap {
                            store.onBackToWritingChevronTapped()
                        }
                        
                    } label: {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .fontWeight(.black)
                            }
                    }
                    .animation(
                        .easeInOut,
                        value: store(\.answeredText).isEmpty
                    )
                    .disabled(store(\.blockButtonDoubleTap))
                    .padding(.leading, 12)
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                    
                    Spacer()
                } else {
                    endConversationButtonBuilder()
                        .padding(.bottom, 20)
                }
            }
            
            
            if store(\.conversationStatus) == .recording {
                TKScrollView(
                    style: .question(
                        question: store(\.questionText),
                        answer: store(\.answeredText),
                        curtainAlignment: .bottom
                    ), curtain: {
                        LinearGradient(
                            colors: [.BaseBGWhite, .clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                )
                .matchedGeometryEffect(id: "QUESTION_TEXT", in: namespaceID)
            }
            
            if !store(\.answeredText).isEmpty {
                VStack {
                    TKScrollView(
                        style: .answer(
                            answer: store(\.answeredText),
                            curtainAlignment: .top
                        ), curtain: {
                            LinearGradient(
                                colors: [.OR5, .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    )
                    .frame(maxHeight: 300)
                }
                .frame(
                    maxHeight: UIScreen.main.bounds.height * 0.55,
                    alignment: .top
                )
                .background {
                    Color.OR5
                        .ignoresSafeArea(edges: .bottom)
                        .matchedGeometryEffect(
                            id: "ORANGE_BACKGROUND",
                            in: namespaceID
                        )
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .opacity
                    )
                )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottom) {
            if store(\.conversationStatus) == .recording {
                bottomListeningButtonBuilder()
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut),
                            removal: .move(edge: .trailing)
                        )
                    )
            }
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
    }
    
    private func bottomListeningButtonBuilder() -> some View {
        HStack(spacing: 24) {
            Spacer()
            
            if store(\.answeredText).isEmpty {
                BDText(text: "듣고 있어요", style: .H1_B_130)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(minWidth: 110, minHeight: 42)
                    .background {
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(
                                cornerRadius: 22,
                                style: .continuous
                            )
                            
                            Rectangle()
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(45))
                                .offset(x: 3)
                        }
                        .compositingGroup()
                        .foregroundStyle(Color.OR5)
                    }
            }
            
            Button {
//                firebaseStore.userDidAction(
//                    .tapped,
//                    "next",
//                    nil
//                )
                firebaseStore.userDidAction(.tapped(.next))
                store.blockButtonDoubleTap {
                    store.onStopRecordingButtonTapped()
                }
                
            } label: {
                TKOrbitCircles(
                    store: store,
                    circleRenderInfos: [
                        CircleRenderInfo(x: -10, y: -4),
                        CircleRenderInfo(x: 0, y: 10),
                        CircleRenderInfo(x: 7, y: -4),
                    ],
                    circleColor: store(\.answeredText).isEmpty
                    ? Color.OR5
                    : Color.white
                )
                .task { store.triggerAnimation(true) }
                .frame(height: 64)
                .overlay {
                    Circle()
                        .foregroundStyle(
                            store(\.answeredText).isEmpty
                            ? Color.OR5
                            : Color.white
                        )
                        .overlay {
                            Image(systemName: "chevron.right")
                                .opacity(
                                    store(\.answeredText).isEmpty
                                    ? 0.0
                                    : 1.0
                                )
                                .foregroundStyle(Color.OR6)
                                .scaleEffect(1.4)
                                .fontWeight(.bold)
                        }
                }
            }
            .disabled(store(\.blockButtonDoubleTap))
        }
    }
    
    private func endConversationButtonBuilder() -> some View {
        HStack {
            Button {
//                firebaseStore.userDidAction(
//                    .tapped,
//                    "cancel",
//                    nil
//                )
                firebaseStore.userDidAction(.tapped(.cancel))
                store.onConversationDismissButtonTapped()
                
            } label: {
                BDText(text: "취소", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(Color.GR6)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(Color.GR1)
            
            Spacer()
            
            Button {
                store.blockButtonDoubleTap {
                    // MARK: Previous가 있다면 DataStore가 책임을 이어받는다.
                    // 그렇지 않다면 conversationViewStore가 책임을 유지한다.
                    
                    if let previousConversation = store(\.previousConversation) {
                        store.makeCurrentConversationContent()
                        dataStore.onSaveOnPreviousConversation(
                            from: store(\.historyItems),
                            into: previousConversation
                        )
                        store.onSaveConversationIntoPreviousButtonTapped()
                        
                    } else {
                        store.onSaveConversationButtonTapped()
                    }
                    
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "save",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.save))
                }
            } label: {
                BDText(text: "저장", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(Color.white)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(Color.OR5)
            .disabled(store(\.blockButtonDoubleTap))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Namespace var namespace
    @ObservedObject var store = TKConversationViewStore()
    
    return TKListeningView(
        store: store, namespaceID: namespace
    )
    .frame(maxHeight: .infinity)
    .onAppear {
        store.reduce(\.conversationStatus, into: .recording)
    }
}
