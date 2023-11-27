//
//  TKListeningView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftUI

struct TKListeningView: View {
    @ObservedObject var store: TKConversationViewStore
    let namespaceID: Namespace.ID
    
    var body: some View {
        VStack {
            HStack {
                if store(\.answeredText).isEmpty {
                    Button {
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
                store.onConversationDismissButtonTapped()
            } label: {
                BDText(text: "취소", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(Color.GR6)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(height: 34)
            .tint(Color.GR1)
            
            Spacer()
            
            Button {
                store.blockButtonDoubleTap {
                    store.onSaveConversationButtonTapped()
                }
            } label: {
                BDText(text: "저장", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(Color.white)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(height: 34)
            .tint(Color.OR5)
            .disabled(store(\.questionText).isEmpty ? true : false)
            .disabled(store(\.blockButtonDoubleTap))
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
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
