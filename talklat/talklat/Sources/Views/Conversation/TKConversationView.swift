//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Combine
import SwiftData
import SwiftUI

struct TKConversationView: View {
    @ObservedObject var store: TKConversationViewStore
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    
    @Namespace var TKTransitionNamespace

    // MARK: Body
    var body: some View {
        VStack {
            if store(\.conversationStatus) == .writing {
                TKTypingView(
                    store: store,
                    namespaceID: TKTransitionNamespace
                )
//                .transition(.offset())
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
                .transition(
                    .asymmetric(
                        insertion: .offset(),
                        removal: .scale(scale: 1)
                    )
                )
                .onChange(of: speechRecognizeManager.currentTranscript) { oldValue, newValue in
                    if oldValue.isEmpty, !newValue.isEmpty {
                        withAnimation {
                            store.onSpeechTranscriptUpdated(newValue)
                        }
                    } else {
                        store.onSpeechTranscriptUpdated(newValue)
                    }
                }
                .toolbar {
                    if store(\.answeredText).isEmpty {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                store.onShowingQuestionCancelButtonTapped()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .bold()
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
        .sheet(
            isPresented: store.bindingSaveConversationViewFlag(),
            onDismiss: {
                store.onDismissSavingViewButtonTapped()
            }
        ) {
            TKSavingView(
                store: store,
                speechRecognizeManager: speechRecognizeManager
            )
            .onDisappear {
                if store(\.conversationStatus) == .recording {
                    speechRecognizeManager.startTranscribing()
                }
            }
            .onAppear {
                speechRecognizeManager.stopAndResetTranscribing()
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
        .onChange(of: store(\.hasSavingViewDisplayed)) { oldValue, newValue in
            if !oldValue, newValue {
                speechRecognizeManager.stopAndResetTranscribing()
                
            } else if oldValue, !newValue,
                      store(\.conversationStatus) == .recording {
                speechRecognizeManager.startTranscribing()
            }
        }
        .onDisappear {
            store.resetConversationState()
        }
    }
}


#Preview {
    TKConversationView(store: .init())
}


