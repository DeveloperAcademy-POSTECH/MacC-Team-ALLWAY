//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import Combine
import SwiftUI

struct TKConversationView: View {
    @FocusState var focusState: Bool
    @Namespace var communicationAnimation
    
    @StateObject private var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    @StateObject private var store: ConversationViewStore = ConversationViewStore(
        conversationState: ConversationViewStore.ConversationState(
            conversationStatus: .writing,
            answeredText: "Answer AnswerAnswer AnswerAnswer AnswerAnswer AnswerAnswer Answer"
        )
    )
        
    // MARK: Body
    var body: some View {
        NavigationStack {
            switch store(\.conversationStatus) {
            case .writing:
                VStack {
                    TLTextField(
                        style: .normal(textLimit: store.questionTextLimit),
                        text: store.bindingQuestionText(),
                        placeholder: Constants.TEXTFIELD_PLACEHOLDER
                    ) {
                        HStack {
                            Button {
                                store.onEraseAllButtonTapped()
                            } label: {
                                Text("전체 지우기")
                            }
                            .opacity(focusState ? 1.0 : 0.0)
                            .animation(
                                .easeInOut(duration: 0.4),
                                value: focusState
                            )
                            
                            Spacer()
                            
                            Link(destination: URL(string: "https://open.kakao.com/o/gRBZZUPf")!) {
                                Text("오픈 카톡방에서 피드백하기")
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .focused($focusState)
                    .background(alignment: .topLeading) {
                        characterLimitViewBuilder()
                            .padding(.top, 40)
                            .padding(.leading, 24)
                            .opacity(focusState ? 1.0 : 0.0)
                            .animation(
                                .easeInOut(duration: 0.5),
                                value: focusState
                            )
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
            case .guiding:
                TKGuidingView(store: store)
                    .frame(maxHeight: .infinity)
                
            case .recording:
                VStack {
                    Text(store(\.questionText))
                        .font(
                            store(\.answeredText).isEmpty
                            ? .largeTitle
                            : .title3
                        )
                        .lineSpacing(
                            store(\.answeredText).isEmpty
                            ? 10
                            : 14
                        )
                        .bold()
                        .multilineTextAlignment(.leading)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                        .padding(.horizontal, 20)
                        .animation(
                            .easeInOut,
                            value: store(\.answeredText).isEmpty
                        )
                    
                    Spacer()

                    if !store(\.answeredText).isEmpty {
                        ScrollViewReader { proxy in
                            ScrollView {
                                Text(store(\.answeredText))
                                    .font(.title)
                                    .bold()
                                    .lineSpacing(14)
                                    .foregroundStyle(.white)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .topLeading
                                    )
                                    .padding(.top, 24)
                                    .padding(.horizontal, 24)
                                    .animation(
                                        nil,
                                        value: store(\.answeredText)
                                    )
                                
                                Rectangle()
                                    .foregroundColor(.accentColor)
                                    .frame(height: 75)
                                    .id("SCROLL_BOTTOM")
                            }
                            .overlay(alignment: .top) {
                                if store(\.answeredText).count > 50 {
                                    scrollViewTopCurtainBuiler()
                                        .frame(height: 50)
                                }
                            }
                            // MARK: Scroll Position Here
                            .onChange(of: store(\.answeredText)) { newValue in
                                if newValue.count > 50 {
                                    withAnimation {
                                        proxy.scrollTo(
                                            "SCROLL_BOTTOM",
                                            anchor: .top
                                        )
                                    }
                                }
                            }
                            .frame(
                                maxHeight: UIScreen.main.bounds.height * 0.55
                            )
                            .scrollIndicators(.hidden)
                            .background {
                                Rectangle()
                                    .foregroundColor(.accentColor)
                                    .ignoresSafeArea(edges: .bottom)
                            }
                        }
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .opacity
                            )
                        )
                    }
                }
                .frame(maxHeight: .infinity)
                .onChange(of: speechRecognizeManager.transcript) { transcript in
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
        .onTapGesture {
            self.hideKeyboard()
        }
        .safeAreaInset(edge: .bottom) {
            if store(\.conversationStatus) == .writing {
                startRecordingButtonBuilder()
            } else if store(\.conversationStatus) == .recording {
                stopRecordButtonBuilder()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .background {
                        if !store(\.answeredText).isEmpty {
                            Color.accentColor
                                .ignoresSafeArea(edges: .bottom)
                        }
                    }
            }
        }
        .safeAreaInset(edge: .top) {
            chevronButtonBuilder()
                .opacity(
                    store.isChevronButtonDisplayable ? 1.0 : 0.0
                )
        }
        .onAppear {
            gyroScopeStore.detectDeviceMotion()
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
        // MARK: - Flip Gesture OnChange Has been Deprecated
        // .onChange(of: gyroScopeStore.faced) { _ in }
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
            Text("위로 스와이프해서 내용을 더 확인하세요.")
                .font(.caption2)
                .bold()
                .opacity(store(\.hasChevronButtonTapped) ? 1.0 : 0.0)
                .overlay {
                    Button {
                        store.onChevronButtonTapped()
                    } label: {
                        Image(systemName: "chevron.compact.up")
                            .resizable()
                            .frame(width: 32, height: 10)
                            .padding()
                    }
                    .offset(
                        y: store(\.hasChevronButtonTapped)
                        ? 20
                        : 0
                    )
                }
        }
        .foregroundColor(.accentColor)
        .animation(
            .easeInOut(duration: 0.5),
            value: store(\.hasChevronButtonTapped)
        )
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        store(\.questionText).count == store.questionTextLimit
    }
}

// MARK: Recording Component Container
extension TKConversationView {
    private func stopRecordButtonBuilder() -> some View {
        Button {
            withAnimation {
                store.onStopRecordingButtonTapped()
            }
            
        } label: {
            Circle()
                .frame(width: 64, height: 64)
                .foregroundColor(
                    store(\.answeredText).isEmpty
                    ? .accentColor
                    : .gray100.opacity(0.8)
                )
        }
        .overlay(alignment: .top) {
            if store(\.answeredText).isEmpty {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .overlay {
                        Text("듣고 있어요")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .background(alignment: .bottom) {
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(45))
                            .offset(y: 5)
                    }
                    .frame(width: 150, height: 50)
                    .offset(y: -75)
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    private func scrollViewTopCurtainBuiler() -> LinearGradient {
        LinearGradient(
            colors: [
                .accentColor,
                .clear,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}


struct TKConversationView_Previews: PreviewProvider {
    static var previews: some View {
        TKConversationView()
    }
}
