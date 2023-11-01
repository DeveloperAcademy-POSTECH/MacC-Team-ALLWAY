//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Combine
import SwiftUI

struct TKConversationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @FocusState var focusState: Bool
    @Namespace var communicationAnimation
    
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    @StateObject private var store: ConversationViewStore = ConversationViewStore(
        communicationState: ConversationViewStore.CommunicationState(communicationStatus: .writing)
    )
    
    // MARK: Body
    var body: some View {
        VStack {
            
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .safeAreaInset(edge: .bottom) {
            if store(\.communicationStatus) == .writing {
                startRecordingButtonBuilder()
            } else if store(\.communicationStatus) == .recording {
                stopRecordButtonBuilder()
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        store(\.answeredText).isEmpty
                        ? Color.white.ignoresSafeArea(edges: .bottom)
                        : Color.gray100.ignoresSafeArea(edges: .bottom)
                    }
            }
        }
        .onAppear {
            gyroScopeStore.detectDeviceMotion()
        }
        .onChange(of: store(\.communicationStatus)) { newStatus in
            switch newStatus {
            case .writing:
                speechRecognizeManager.stopAndResetTranscribing()
                
            case .recording:
                speechRecognizeManager.startTranscribing()
                
            }
        }
        // MARK: - Flip Gesture OnChange Has been Deprecated
        // .onChange(of: gyroScopeStore.faced) { _ in }
        .onChange(of: scenePhase) { _ in
            Color.colorScheme = UITraitCollection.current.userInterfaceStyle
        }
    }
}

// TODO: Component Container..?
extension TKConversationView {
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
    
    private func answerTextCardViewBuilder(_ lastItem: HistoryItem) -> some View {
        VStack {
            ScrollView {
                Text(lastItem.text)
                    .font(.title3)
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 200)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 40)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray100)
                .padding(.horizontal, 20)
        }
    }
    
    private func startRecordingButtonBuilder() -> some View {
        Button {
            store.onStartRecordingButtonTapped()
            speechRecognizeManager.startTranscribing()
            
        } label: {
            Text("**음성 인식 전환**")
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
                .background {
                    Capsule()
                        .foregroundColor(.gray)
                }
        }
    }
    
    private func characterLimitViewBuilder() -> some View {
        Text("\(store(\.questionText).count)/\(store.questionTextLimit)")
            .font(.system(size: 12, weight: .regular))
            .monospacedDigit()
            .foregroundColor(
                hasQuestionTextReachedMaximumCount
                ? .red
                : .gray
            )
    }
    
    private func chevronButtonBuilder() -> some View {
        VStack {
            if store(\.hasChevronButtonTapped) {
                Text("위로 스와이프해서 내용을 더 확인하세요.")
                    .font(.caption2)
                    .foregroundColor(.gray500)
                    .opacity(store(\.hasChevronButtonTapped) ? 1.0 : 0.0)
            }
            
            Button {
                store.onChevronButtonTapped()
            } label: {
                Image(systemName: "chevron.compact.up")
                    .resizable()
                    .frame(width: 32, height: 10)
                    .foregroundColor(.gray400)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
        .background {
            Color.white.opacity(0.3)
        }
    }
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        store(\.questionText).count == store.questionTextLimit
    }
}

// MARK: Recording Component Container
extension TKConversationView {
    private func guideMessageBuilder() -> some View {
        Text(Constants.GUIDE_MESSAGE)
            .font(.title)
            .bold()
            .multilineTextAlignment(.leading)
            .lineSpacing(12)
            .foregroundColor(.gray)
    }
    
    private func stopRecordButtonBuilder() -> some View {
        Button {
            store.onStopRecordingButtonTapped()
            
        } label: {
            Image(systemName: "square.fill")
                .foregroundColor(.white)
                .padding()
                .background {
                    Circle()
                        .foregroundColor(.gray)
                }
        }
    }
}


struct TKConversationView_Previews: PreviewProvider {
    static var previews: some View {
        TKConversationView()
    }
}
