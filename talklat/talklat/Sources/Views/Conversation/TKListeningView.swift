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
                .opacity(
                    store(\.answeredText).isEmpty
                    ? 1.0
                    : 0.0
                )
                .animation(
                    .easeInOut,
                    value: store(\.answeredText).isEmpty
                )
                .disabled(store(\.blockButtonDoubleTap))
                
                Spacer()
                
                Button {
                    store.onSaveConversationButtonTapped()
                } label: {
                    Text("종료")
                        .font(.headline)
                        .foregroundStyle(Color.gray700)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(Color.gray200)
                .opacity(
                    store(\.answeredText).isEmpty
                    ? 0.0
                    : 1.0
                )
                .animation(
                    .easeInOut,
                    value: store(\.answeredText).isEmpty
                )
            }
            .padding(.leading, 12)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            
            TKScrollView(
                style: .question(
                    question: store(\.questionText),
                    answer: store(\.answeredText),
                    curtainAlignment: .bottom
                ), curtain: {
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }
            )
            
            if !store(\.answeredText).isEmpty {
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
                        removal: .identity
                    )
                )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottom) {
            if store(\.conversationStatus) == .recording {
                bottomListeningButtonBuilder()
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
                Text("듣고 있어요")
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .frame(minWidth: 110, minHeight: 50)
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
                Circle()
                    .frame(width: 64, height: 64)
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
            .disabled(store(\.blockButtonDoubleTap))
        }
        .padding(.trailing, 24)
    }
}

struct TKListeningView_Preview: PreviewProvider {
    static var previews: some View {
        TKConversationView(
            store: .init()
        )
    }
}
