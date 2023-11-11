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
    @Namespace var questionTextSpace
    
    // MARK: Body
    var body: some View {
        VStack {
            if store(\.conversationStatus) == .writing {
                TKTypingView(store: store)
                    .transition(.opacity)
                
            } else if store(\.conversationStatus) == .guiding {
                TKGuidingView(store: store)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity)
                
            } else if store(\.conversationStatus) == .recording {
                TKListeningView(store: store)
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
                                } label : {
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
