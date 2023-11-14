//
//  TKTypingView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftUI

struct TKTypingView: View {
    @ObservedObject var store: TKConversationViewStore
    @FocusState var focusState: Bool
    let namespaceID: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            if store.isAnswerCardDisplayable {
                VStack(alignment: .leading) {
                    conversationPreviewChevronBuilder()
                    
                    if let recentAnswer = store(\.historyItems).last(where: {
                        $0.type == .answer
                    }) {
                        TKScrollView(
                            style: .answerCard(
                                text: recentAnswer.text,
                                curtainAlignment: .bottom
                            ), curtain: {
                                LinearGradient(
                                    colors: [],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            }
                        )
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 250,
                    alignment: .top
                )
                .background {
                    Color.OR5
                        .matchedGeometryEffect(
                            id: "ORANGE_BACKGROUND",
                            in: namespaceID
                        )
                        .ignoresSafeArea(edges: .top)
                }
                
            } else {
                endConversationButtonBuilder()
            }
            
            Spacer()
                .frame(maxHeight: 32)
            
            characterLimitViewBuilder()
                .opacity(focusState ? 1.0 : 0.0)
                .animation(
                    .easeInOut(duration: 0.5),
                    value: focusState
                )
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.leading, 24)
                .padding(.bottom, 6)
            
            if store(\.conversationStatus) == .writing {
                TLTextField(
                    style: .typing(
                        textLimit: store.questionTextLimit
                    ),
                    text: store.bindingQuestionText(),
                    placeholder: Constants.TEXTFIELD_PLACEHOLDER
                ) {
                    EmptyView()
                }
                .frame(maxWidth: .infinity)
                .focused($focusState)
                .matchedGeometryEffect(id: "QUESTION_TEXT", in: namespaceID)
            }
            
            Spacer()
            
            startRecordingButtonBuilder()
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
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
    
    private func startRecordingButtonBuilder() -> some View {
        Button {
            self.hideKeyboard()
            store.blockButtonDoubleTap {
                store.onStartRecordingButtonTapped()
            }
            
        } label: {
            Text("음성 인식 전환")
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
        }
        .background {
            Capsule()
                .foregroundStyle(Color.OR5)
        }
        .disabled(store(\.blockButtonDoubleTap))
    }
    
    private func conversationPreviewChevronBuilder() -> some View {
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
                            ? 16
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
                        
                        endConversationButtonBuilder()
                    }
                    .opacity(
                        store.isAnswerCardDisplayable
                        ? 1.0
                        : 0.0
                    )
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
    
    private func endConversationButtonBuilder() -> some View {
        HStack {
            Spacer()
            
            Button {
                store.blockButtonDoubleTap {
                    store.onSaveConversationButtonTapped()
                }
                
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
            .disabled(store(\.blockButtonDoubleTap))
        }
        .padding(.trailing, 24)
    }
}

#Preview {
    TKConversationView(store: .init())
}