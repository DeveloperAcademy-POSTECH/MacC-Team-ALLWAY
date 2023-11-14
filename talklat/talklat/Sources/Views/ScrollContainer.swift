//
//  NewTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

struct ScrollContainer: View {
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @ObservedObject var store: TKConversationViewStore
    
    var body: some View {
        Group {
            if store(\.conversationStatus) == .guiding {
                TKGuidingView(store: store)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity)
                
            } else {
                GeometryReader { _ in
                    VStack(spacing: 0) {
                        // View 1
                        if store(\.conversationStatus) == .writing {
                            TKHistoryView(store: store)
                                .frame(
                                    maxHeight: store(\.isTopViewShown)
                                    ? .infinity // 임시방편
                                    : 0
                                )
                                .overlay(alignment: .bottom) {
                                    HStack {
                                        Button {
                                            store.onScrollOffsetChanged(false)
                                            
                                        } label: {
                                            Image(systemName: "chevron.compact.down")
                                                .resizable()
                                                .frame(width: 32, height: 10)
                                                .foregroundColor(.gray500)
                                        }
                                        .opacity(
                                            store(\.isTopViewShown)
                                            ? 1.0
                                            : 0.0
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                        }
                        
                        // View 2
                        TKConversationView(
                            store: store
//                            ,speechRecognizeManager: speechRecognizeManager
                        )
                        .frame(
                            height: store(\.isTopViewShown) && store(\.conversationStatus) == .writing
                            ? 0
                            : store(\.deviceHeight) + store(\.bottomInset) // 임시방편
                        )
                        .ignoresSafeArea(
                            .keyboard,
                            edges: .bottom
                        )
                    }
                    .onChange(of: store(\.isTopViewShown)) { _, shown in
                        if shown {
                            hideKeyboard()
                        }
                    }
                }
                .background {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.clear)
                            .onAppear {
                                if let insets = UIApplication.shared.windows.first?.safeAreaInsets {
                                    store.onScrollContainerAppear(
                                        geo: geo,
                                        insets: insets
                                    )
                                }
                            }
                    }
                }
                .background(alignment: .top) {
                    if store(\.conversationStatus) == .writing,
                       !store(\.isHistoryViewShownWithTransition) {
                        Color.OR5
                            .frame(height: 200)
                            .ignoresSafeArea()
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .top),
                                    removal: .identity
                                )
                            )
                    }
                }
                .overlay(alignment: .bottom) {
                    if store(\.conversationStatus) == .recording,
                       !store(\.answeredText).isEmpty {
                        bottomListeningButtonBuilder()
                            .background { Color.OR6.ignoresSafeArea(edges: .bottom) }
                    }
                }
            }
            
            if !store(\.isTopViewShown),
               store(\.conversationStatus) == .writing {
                startRecordingButtonBuilder()
            }
        }
        .onChange(of: store(\.conversationStatus)) { _, newStatus in
            switch newStatus {
            case .writing:
                speechRecognizeManager.stopAndResetTranscribing()
                break
                
            case .guiding:
                break
                
            case .recording:
                speechRecognizeManager.startTranscribing()
                break
            }
        }
    }
    
    private func bottomListeningButtonBuilder() -> some View {
        HStack(spacing: 24) {
            Spacer()
            
            if store(\.answeredText) == "" {
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
                store.onStopRecordingButtonTapped()
                
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
        }
        .padding(.trailing, 24)
    }
    
    private func scrollIndicateChevronBuilder() -> some View {
        VStack {
            HStack {
                ZStack {
                    Group {
                        Button {
                            store.onChevronButtonTapped()
                        } label: {
                            Image(systemName: "chevron.compact.up")
                                .resizable()
                                .frame(width: 32, height: 10)
                                .padding()
                                .foregroundStyle(Color.white)
                        }
                        .offset(
                            y: store(\.hasChevronButtonTapped)
                            ? 20
                            : 0
                        )
                        
                        Text("위로 스와이프해서 내용을 더 확인하세요.")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(Color.white)
                            .opacity(
                                store(\.hasChevronButtonTapped)
                                ? 1.0
                                : 0.0
                            )
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            store.onSaveConversationButtonTapped()
                        } label: {
                            Text("종료")
                                .font(.headline)
                                .padding(.horizontal, 6)
                                .foregroundStyle(
                                    store(\.answeredText).isEmpty
                                    ? Color.gray700
                                    : Color.OR5
                                )
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(
                            store(\.answeredText).isEmpty
                            ? Color.gray200
                            : Color.white
                        )
                    }
                    .padding(.trailing, 24)
                }
            }
        }
        .animation(
            .easeInOut(duration: 0.5),
            value: store(\.hasChevronButtonTapped)
        )
        .opacity(
            store(\.isTopViewShown)
            ? 0.0
            : 1.0
        )
    }
}

// MARK: - Button Components
extension ScrollContainer {
    // 전체 지우기 버튼
    private func eraseAllButtonBuilder() -> some View {
        Button {
            store.onEraseAllButtonTapped()
        } label: {
            Text("전체 지우기")
                .foregroundColor(
                    store(\.questionText).isEmpty
                    ? .gray.opacity(0.5)
                    : .gray
                )
        }
    }
    
    // Writing 뷰 버튼
    private func startRecordingButtonBuilder() -> some View {
        Button {
            self.hideKeyboard()
            store.onStartRecordingButtonTapped()
            
        } label: {
            Text("음성 인식 전환")
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
                .background {
                    Capsule()
                        .foregroundColor(.accentColor)
                }
        }
    }
}

#Preview {
    ScrollContainer(store: .init())
}
