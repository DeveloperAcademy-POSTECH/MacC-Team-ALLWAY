//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Combine
import SwiftUI

struct TKCommunicationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @FocusState var focusState: Bool
    @Namespace var communicationAnimation
    
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    @StateObject private var store: CommunicationViewStore = CommunicationViewStore(
        communicationState: CommunicationViewStore.CommunicationState(
            communicationStatus: .writing,
            questionText: "A long string of text that goes on an A long string of text A long string of text that goes on an A long string of text that goes on an A long string of text that goes on an that goes on an text that goes on an A long"
        )
    )
    
    // MARK: Body
    var body: some View {
        VStack {
            if store(\.communicationStatus) == .writing {
                if let historyItem = store(\.historyItems).last,
                   !store(\.answeredText).isEmpty {
                    answerTextCardViewBuilder(historyItem)
                        .padding(.top, 32)
                        .transition(
                            .asymmetric(
                                insertion: .opacity,
                                removal: .move(edge: .top)
                            )
                        )
                        .animation(.easeInOut, value: store(\.communicationStatus))
                        .matchedGeometryEffect(
                            id: 
                                store(\.communicationStatus) == .writing
                                ? TKTransitionObjects.ANSWER
                                : TKTransitionObjects.INTERLUDE
                            ,
                            in: communicationAnimation
                        )
                        .overlay(alignment: .top) {
                            if !store(\.historyItems).isEmpty {
                                chevronButtonBuilder()
                            }
                        }
                }
                
                // MARK: TEXTFIELD ITEM ANIMATIONS DONE
                // TODO: TEXTFIELD -> QUESTIONTEXT matching
                TLTextField(
                    style: .normal(textLimit: 160),
                    text: store.bindingQuestionText(),
                    placeholder: "탭해서 전하고 싶은 내용을 작성해 주세요."
                ) {
                    eraseAllButtonBuilder()
                        .opacity(focusState ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.2), value: focusState)
                }
                .focused($focusState)
                .overlay(alignment: .topLeading) {
                    characterLimitViewBuilder()
                        .padding(.leading, 24)
                        .padding(.top, 36)
                        .opacity(focusState ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.4), value: focusState)
                }
                .padding(.top, 24)
                .matchedGeometryEffect(
                    id: store(\.communicationStatus) == .writing
                    ? TKTransitionObjects.QUESTION
                    : TKTransitionObjects.INTERLUDE,
                    in: communicationAnimation
                )
                
                Spacer()
            }
            
            if store(\.communicationStatus) == .recording {
                if !store(\.hasGuidingMessageShown) {
                    guideMessageBuilder()
                        .padding(.top, 24)
                    
                } else if store(\.hasGuidingMessageShown) {
                    EmptyView()
                }
                
                ScrollView {
                    Text(store(\.questionText))
                        .font(
                            store(\.answeredText).isEmpty
                            ? .title2
                            : .headline
                        )
                        .foregroundColor(
                            store(\.answeredText).isEmpty
                            ? .gray900
                            : .gray700
                        )
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        
                }
                .padding(.top, 24)
                .frame(height: 250)
                .scrollIndicators(.hidden)
                .animation(.none, value: store(\.communicationStatus))
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top)
                    )
                )
                .animation(.easeOut, value: store(\.communicationStatus))
                .matchedGeometryEffect(
                    id: store(\.communicationStatus) == .writing
                    ? TKTransitionObjects.QUESTION
                    : TKTransitionObjects.INTERLUDE,
                    in: communicationAnimation
                )
                .onChange(of: speechRecognizeManager.transcript) { transcript in
                    store.onSpeechTransicriptionUpdated(transcript)
                }
                
                Spacer()
                
                if !store(\.answeredText).isEmpty {
                    ScrollView {
                        Text(store(\.answeredText))
                            .font(.title2)
                            .bold()
                            .lineSpacing(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                    }
                    .padding(.top, 12)
                    .background { Color.gray100.ignoresSafeArea(edges: .bottom) }
                    .scrollIndicators(.hidden)
                    .matchedGeometryEffect(
                        id: TKTransitionObjects.ANSWER,
                        in: communicationAnimation
                    )
                }
            }
        }
        .animation(.spring(), value: store(\.communicationStatus))
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
        .onChange(of: gyroScopeStore.faced) { facedStatus in
            switch facedStatus {
            case .myself:
                store.onWritingViewAppear()
                
            case .opponent:
                store.onRecordingViewAppear()
            }
        }
        .onChange(of: scenePhase) { _ in
            Color.colorScheme = UITraitCollection.current.userInterfaceStyle
        }
    }
}

// TODO: Component Container..?
extension TKCommunicationView {
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
extension TKCommunicationView {
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


struct TKIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKCommunicationView()
    }
}
