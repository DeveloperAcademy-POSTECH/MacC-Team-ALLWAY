//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Combine
import SwiftUI

struct TKConversationView: View {
    @ObservedObject var store: TKConversationViewStore
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    @Namespace var TKTransitionNamespace
    
    // MARK: Body
    var body: some View {
        VStack {
            if store(\.conversationStatus) == .writing {
                TKTypingView(
                    store: store,
                    namespaceID: TKTransitionNamespace
                )
                .transition(.opacity)
            }
            
            if store(\.conversationStatus) == .guiding {
                TKGuidingView(store: store)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity)
            }
            
            if store(\.conversationStatus) == .recording {
                TKListeningView(
                    store: store,
                    namespaceID: TKTransitionNamespace
                )
                .onChange(of: speechRecognizeManager.transcript) { _, transcript in
                    withAnimation {
                        store.onSpeechTransicriptionUpdated(transcript)
                    }
                }
                .toolbar {
                    if store(\.answeredText).isEmpty {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                store.onShowingQuestionCancelButtonTapped()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onTapGesture {
            self.hideKeyboard()
        }
        .sheet(isPresented: store.bindingSaveConversationViewFlag()) {
            TKSavingView(store: store)
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
        // MARK: - Flip Gesture OnChange Has been Deprecated
        // .onChange(of: gyroScopeStore.faced) { _ in }
        // .onAppear { gyroScopeStore.detectDeviceMotion() }
    }
}

#Preview {
    TKConversationView(store: .init())
}

// MARK: BACKUP
//var body: some View {
//    OffsetObservingScrollView(offset: $offset) {
//        VStack {
//            if store(\.conversationStatus) == .writing {
//                TKTypingView(store: store)
//                    .transition(.opacity)
//                
//            } else if store(\.conversationStatus) == .recording {
//                TKListeningView(store: store)
//                    .transition(.opacity)
//                    .onChange(of: speechRecognizeManager.transcript) { _, transcript in
//                        withAnimation {
//                            store.onSpeechTransicriptionUpdated(transcript)
//                        }
//                    }
//                    .toolbar {
//                        if store(\.answeredText).isEmpty {
//                            ToolbarItem(placement: .topBarLeading) {
//                                Button {
//                                    store.onShowingQuestionCancelButtonTapped()
//                                } label : {
//                                    Image(systemName: "chevron.left")
//                                        .foregroundColor(.accentColor)
//                                }
//                            }
//                        }
//                    }
//            }
//        }
//        .frame(height: store(\.deviceHeight))
//        .onChange(of: offset) { _, offset in
//            if offset.y < -110,
//               store(\.conversationStatus) == .writing,
//               store.isTopPreviewChevronDisplayable {
//                store.onScrollOffsetChanged(true)
//            }
//        }
//        .onTapGesture {
//            self.hideKeyboard()
//        }
//        .sheet(isPresented: store.bindingSaveConversationViewFlag()) {
//            TKSavingView(store: store)
//        }
//    }
//    .frame(maxWidth: .infinity)
//    // MARK: - Flip Gesture OnChange Has been Deprecated
//    // .onChange(of: gyroScopeStore.faced) { _ in }
//    // .onAppear { gyroScopeStore.detectDeviceMotion() }
//    }
//
//// MARK: - Components
//// TODO: Component Container..?
//extension TKConversationView {
//    private func chevronButtonBuilder() -> some View {
//        VStack {
//            Text("위로 스와이프해서 내용을 더 확인하세요.")
//                .font(.caption2)
//                .bold()
//                .opacity(store(\.hasChevronButtonTapped) ? 1.0 : 0.0)
//                .overlay {
//                    Button {
//                        store.onChevronButtonTapped()
//                    } label: {
//                        Image(systemName: "chevron.compact.up")
//                            .resizable()
//                            .frame(width: 32, height: 10)
//                            .padding()
//                    }
//                    .offset(
//                        y: store(\.hasChevronButtonTapped)
//                        ? 20
//                        : 0
//                    )
//                }
//        }
//        .foregroundColor(.accentColor)
//        .animation(
//            .easeInOut(duration: 0.5),
//            value: store(\.hasChevronButtonTapped)
//        )
//        .opacity(store(\.isTopViewShown)
//                 ? 0.0
//                 : 1.0
//        )
//        .frame(maxWidth: .infinity)
//        .padding(.bottom, 10)
//    }
//    
//    private func characterLimitViewBuilder() -> some View {
//        Text("\(store(\.questionText).count)/\(store.questionTextLimit)")
//            .font(.system(size: 12, weight: .regular))
//            .monospacedDigit()
//            .foregroundColor(
//                hasQuestionTextReachedMaximumCount
//                ? .red
//                : .gray
//            )
//    }
//    
//    private var hasQuestionTextReachedMaximumCount: Bool {
//        store(\.questionText).count == store.questionTextLimit
//    }
//}
//
//// MARK: Recording Component Container
//extension TKConversationView {
//    private func scrollViewTopCurtainBuilder() -> LinearGradient {
//        LinearGradient(
//            colors: [
//                .accentColor,
//                .clear,
//            ],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//    }
//    
//    // Recording 뷰 버튼
//    private func stopRecordButtonBuilder() -> some View {
//        Button {
//            withAnimation {
//                store.onStopRecordingButtonTapped()
//            }
//            
//        } label: {
//            Circle()
//                .frame(width: 64, height: 64)
//                .foregroundColor(
//                    store(\.answeredText).isEmpty
//                    ? .accentColor
//                    : .gray100.opacity(0.8)
//                )
//        }
//        .overlay(alignment: .top) {
//            if store(\.answeredText).isEmpty {
//                RoundedRectangle(cornerRadius: 12, style: .continuous)
//                    .overlay {
//                        Text("듣고 있어요")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                    .background(alignment: .bottom) {
//                        Rectangle()
//                            .frame(width: 20, height: 20)
//                            .rotationEffect(.degrees(45))
//                            .offset(y: 5)
//                    }
//                    .frame(width: 150, height: 50)
//                    .offset(y: -75)
//                    .foregroundColor(.accentColor)
//            }
//        }
//    }
//}
//
//
//struct TKConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollContainer()
//    }
//}

