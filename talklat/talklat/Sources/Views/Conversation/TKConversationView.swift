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
    
    @StateObject private var gyroScopeStore: GyroScopeStore = GyroScopeStore()
    
    @State var offset: CGPoint = .zero
    
    @ObservedObject var store: ConversationViewStore
    @ObservedObject var speechRecognizeManager: SpeechRecognizer
    
    // MARK: Body
    var body: some View {
        OffsetObservingScrollView(offset: $offset) {
            VStack {
                if store(\.conversationStatus) == .writing {
                    VStack {
                        chevronButtonBuilder()
                            .opacity(
                                store.isChevronButtonDisplayable ? 1.0 : 0.0
                            )
                        
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
                                
//                                Link(destination: URL(string: "https://open.kakao.com/o/gRBZZUPf")!) {
//                                    Text("오픈 카톡방에서 피드백하기")
//                                }
                                Button {
                                    withAnimation {
                                        store.reduce(\.conversationStatus, into: .writing)
                                        store.reduce(\.isTopViewShown, into: true)
                                    }
                                } label: {
                                    Text("Go up")
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
                } else if store(\.conversationStatus) == .recording {
                    VStack {
                        Spacer()
                            .frame(height: 60)
                        
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
                                        .foregroundColor(.clear)
                                        .frame(height: 1)
                                        .id("SCROLL_BOTTOM")
                                }
                                .overlay(alignment: .top) {
                                    scrollViewTopCurtainBuilder()
                                        .frame(height: 50)
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
                    .safeAreaInset(edge: .bottom) {
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
                    .onChange(of: speechRecognizeManager.transcript) { transcript in
                        withAnimation {
                            store.onSpeechTransicriptionUpdated(transcript)
                        }
                    }
                    .onAppear {
                        self.hideKeyboard()
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
            .frame(height: store(\.deviceHeight))
            .onChange(of: offset) { offset in
                if offset.y < -110,
                   store(\.conversationStatus) == .writing,
                   store.isChevronButtonDisplayable {
                    withAnimation(
                        .spring(
                            response: 0.5,
                            dampingFraction: 0.7,
                            blendDuration: 0.5
                        )
                    ) {
                        store.onScrollOffsetChanged(true)
                    }
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            .onAppear {
                gyroScopeStore.detectDeviceMotion()
            }
        }
        .background(alignment: .bottom) {
            if !store(\.answeredText).isEmpty,
               store(\.conversationStatus) == .recording {
                VStack {
                    Spacer()
                    Color.accentColor
                }
                .frame(height: 100)
            }
        }
        // MARK: - Flip Gesture OnChange Has been Deprecated
        // .onChange(of: gyroScopeStore.faced) { _ in }
    }
}



// MARK: - Components
// TODO: Component Container..?
extension TKConversationView {
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
        .opacity(store(\.isTopViewShown)
                 ? 0.0
                 : 1.0
        )
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
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
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        store(\.questionText).count == store.questionTextLimit
    }
}



// MARK: Recording Component Container
extension TKConversationView {
    private func scrollViewTopCurtainBuilder() -> LinearGradient {
        LinearGradient(
            colors: [
                .accentColor,
                .clear,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // Recording 뷰 버튼
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
}


struct TKConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollContainer()
    }
}
