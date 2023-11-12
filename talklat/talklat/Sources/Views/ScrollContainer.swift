//
//  NewTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

struct ScrollContainer: View {
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @ObservedObject var store: ConversationViewStore
    
    var body: some View {
        Group {
            if store(\.conversationStatus) == .guiding {
                TKGuidingView(store: store)
                    .frame(maxHeight: .infinity)
                
            } else {
                GeometryReader { _ in
                    VStack {
                        // View 1
                        if store(\.conversationStatus) == .writing {
                            TKHistoryView(store: store)
                                .frame(
                                    maxHeight: store(\.isTopViewShown)
                                    ? .infinity // 임시방편
                                    : 0
                                )
                                .overlay(alignment: .bottom) {
                                    CustomHistoryView(conversationViewStore: store)
                                }
                        }
                        
                        // View 2
                        TKConversationView(
                            store: store,
                            speechRecognizeManager: speechRecognizeManager
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
                    .onChange(of: store(\.isTopViewShown)) { _ in
                        if store(\.isTopViewShown) {
                            hideKeyboard()
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
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
            }
            
            if !store(\.isTopViewShown),
               store(\.conversationStatus) == .writing {
                startRecordingButtonBuilder()
            }
        }
        .onChange(of: store(\.conversationStatus)) { newStatus in
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
            withAnimation {
                store.onStartRecordingButtonTapped()
            }
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
    ScrollContainer(store: .init(conversationState: .init(conversationStatus: .writing)))
}




//struct ScrollContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ScrollContainer(appViewStore: .makePreviewStore(condition: { store in
//                store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
//                store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
//                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
//            }))
//        }
//    }
//}
