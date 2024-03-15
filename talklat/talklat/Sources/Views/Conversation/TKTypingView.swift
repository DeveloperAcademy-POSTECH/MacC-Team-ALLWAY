//
//  TKTypingView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftUI
import SwiftData

struct TKTypingView: View {
    // TextReplacement
    @Environment(\.dismiss) private var dismiss
    @Environment(TKSwiftDataStore.self) private var dataStore
    
    @ObservedObject var store: TKConversationViewStore
    @FocusState var focusState: Bool
    
    @State private var matchedTextReplacement: TKTextReplacement? = nil
    let namespaceID: Namespace.ID
    
    var body: some View {
        ZStack {
            if store(\.isTopViewShown) {
                NavigationStack {
                    TKHistoryView(store: store)
                        .frame(
                            maxHeight: store(\.isTopViewShown)
                            ? .infinity
                            : 0
                        )
                        .onAppear() {
                            store.onTKHistoryPreviewAppeared()
                        }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).animation(.easeInOut(duration: 1.0)),
                        removal: .push(from: .bottom).animation(.easeInOut(duration: 1.0))
                    )
                )
                
            } else {
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
                        .padding(.bottom, 24)
                        .background {
                            Color.OR5
                                .matchedGeometryEffect(
                                    id: "ORANGE_BACKGROUND",
                                    in: namespaceID
                                )
                                .ignoresSafeArea()
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .focused($focusState)
                        .matchedGeometryEffect(id: "QUESTION_TEXT", in: namespaceID)
                        
                    }
                    
                    Spacer()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onTapGesture {
            focusState = false
        }
        .task {
            if !focusState {
                focusState = true
            }
        }
        .overlay(alignment: .bottom) {
            if !store(\.isTopViewShown) {
                customToolbar()
                    .padding(.bottom, 16)
            }
        }
    }
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        store(\.questionText).count == store.questionTextLimit
    }
            
    private func isSaveButtonDisabled() -> Bool {
        // historyItems가 비어있고 questionText가 비어 있을 때 -> true
        // historyItems는 비어있지 않고 questionText만 비어있을 때 -> false
        if store(\.questionText).isEmpty && store(\.historyItems).isEmpty {
            return true
        } else if store(\.questionText).isEmpty && !store(\.historyItems).isEmpty {
            return false
        } else {
            return false
        }
    }
}

// MARK: View Builders
extension TKTypingView {
    private func characterLimitViewBuilder() -> some View {
        BDText(text: "\(store(\.questionText).count)/\(store.questionTextLimit)", style: .C1_SB_130)
            .monospacedDigit()
            .foregroundColor(
                hasQuestionTextReachedMaximumCount
                ? .red
                : .gray
            )
    }
    
    private func startRecordingButtonBuilder() -> some View {
        Button {
            self.hideKeyboard()
            store.blockButtonDoubleTap {
                store.onStartRecordingButtonTapped()
            }
            
        } label: {
            TKOrbitCircles(
                store: store,
                circleRenderInfos: [
                    CircleRenderInfo(x: -10, y: -4),
                    CircleRenderInfo(x: 0, y: 10),
                    CircleRenderInfo(x: 7, y: -4),
                ],
                circleColor: Color.OR5
            )
            .animation(.none, value: store(\.animationFlag))
            .frame(height: 64)
            .overlay {
                Circle()
                    .foregroundStyle(Color.OR5)
                    .overlay {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.white)
                            .scaleEffect(1.4)
                            .fontWeight(.bold)
                    }
            }
        }
        .disabled(store(\.blockButtonDoubleTap))
    }
    
    private func conversationPreviewChevronBuilder() -> some View {
        VStack {
            HStack {
                ZStack {
                    Group {
                        Button {
                            focusState = false
                            store.onShowPreviewChevronButtonTapped()
                            
                        } label: {
                            Image(systemName: "chevron.compact.up")
                                .resizable()
                                .frame(width: 32, height: 10)
                                .padding()
                                .foregroundStyle(Color.white)
                        }
                        
                        endConversationButtonBuilder()
                    }
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
            Button {
                store.onConversationDismissButtonTapped()
                
            } label: {
                BDText(text: "취소", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(cancelButtonTextColor())
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(cancelButtonTintColor())
            
            Spacer()
            
            if let previousConversation = store(\.previousConversation),
               !store.isAnswerCardDisplayable {
                Label(
                    previousConversation.title,
                    systemImage: "location.fill"
                )
                .font(.headline)
                .foregroundStyle(Color.GR9)
                .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                store.blockButtonDoubleTap {
                    // MARK: Previous가 있다면 DataStore가 책임을 이어받는다.
                    // 그렇지 않다면 conversationViewStore가 책임을 유지한다.
                    if let previousConversation = store(\.previousConversation) {
                        store.makeCurrentConversationContent()
                        dataStore.onSaveOnPreviousConversation(
                            from: store(\.historyItems),
                            into: previousConversation
                        )
                        
                        store.onSaveConversationIntoPreviousButtonTapped()
                        
                    } else {
                        store.onSaveConversationButtonTapped()
                    }
                }
                
            } label: {
                BDText(text: "저장", style: .H1_B_130)
                    .padding(.horizontal, 6)
                    .foregroundStyle(saveButtonTextColor())
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(saveButtonTintColor())
            .disabled(isSaveButtonDisabled())
            .disabled(store(\.blockButtonDoubleTap))
        }
        .padding(.horizontal, 20)
    }
    
    private func customToolbar() -> some View {
        ZStack(alignment: .bottomLeading) {
            HStack(spacing: 12) {
                // MARK: Eraser button
                Button {
                    store.onEraseAllButtonTapped()
                    
                } label: {
                    Image(systemName: "eraser.fill")
                        .font(.system(size: 23))
                        .foregroundColor(Color.GR1)
                        .padding(13)
                        .background(!store(\.questionText).isEmpty ? Color.GR3 : Color.GR2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .accessibilityLabel(Text("Clear text"))
                
                if focusState {
                    // MARK: TextReplacement Button
                    if
                        let key = replacementKeyForCurrentText(),
                        let replacements = dataStore.textReplacements.first(where: {
                            $0.wordDictionary[key] != nil
                        })?.wordDictionary[key],
                        let firstReplacement = replacements.first { // 첫 번째 요소를 사용
                        
                        Button {
                            store.onTextReplaceButtonTapped(
                                with: firstReplacement,
                                key: key
                            )
                            
                        } label: {
                            BDText(text: firstReplacement, style: .H2_SB_135)
                                .foregroundColor(Color.GR7)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .lineLimit(1)
                                .background {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.GR1)
                                }
                        }
                        .padding(.vertical, 4)
                        .padding(.trailing, 6)
                    }
                }
            }
            .background(focusState ? Color.GR2 : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(.leading, 16)
            .frame(
                maxWidth: 275,
                alignment: .leading
            )
            .transition(.move(edge: .bottom))
            .animation(.default, value: focusState)
            
            startRecordingButtonBuilder()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 24)
                .padding(.top, 32)
        }
    }
    
    private func saveButtonTextColor() -> Color {
        if store.isAnswerCardDisplayable {
            return Color.OR6
        } else if store(\.questionText).isEmpty {
            return Color.GR3
        } else {
            return Color.white
        }
    }
    
    private func saveButtonTintColor() -> Color {
        if store.isAnswerCardDisplayable {
            return Color.white
        } else if store(\.questionText).isEmpty {
            return Color.GR2
        } else {
            return Color.OR5
        }
    }
    
    private func cancelButtonTextColor() -> Color {
        if store.isAnswerCardDisplayable {
            return Color.white
        } else {
            return Color.GR6
        }
    }
    
    private func cancelButtonTintColor() -> Color {
        if store.isAnswerCardDisplayable {
            return Color.OR6
        } else {
            return Color.GR1
        }
    }
}

// MARK: 텍스트 대치 검사
extension TKTypingView {
    // 마지막 단어 또는 부분 문자열이 key와 일치하는 지 검사
    func replacementKeyForCurrentText() -> String? {
        let currentText = store(\.questionText).lowercased()
        let sortedKeys = dataStore.textReplacements.flatMap { list in
            list.wordDictionary.keys
        }.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

        // 문자열의 끝에서부터 시작하여 가장 긴 일치하는 부분 문자열을 찾음
        for key in sortedKeys {
            if currentText.hasSuffix(key.lowercased()) {
                return key
            }
        }
        return nil
    }
}

#Preview {
    TKConversationView(store: TKConversationViewStore())
}
