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
    private let speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    
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
                .task { @MainActor [weak speechRecognizeManager] in
                    if let speechRecognizeManager {
                        speechRecognizeManager.currentTranscript
                            .debounce(
                                for: .milliseconds(300),
                                scheduler: RunLoop.main
                            )
                            .sink { [weak store] in store?.onSpeechTransicriptionUpdated($0) }
                            .store(in: &speechRecognizeManager.cancellableSet)
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
                speechRecognizeManager.cancellableSet.removeAll()
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
