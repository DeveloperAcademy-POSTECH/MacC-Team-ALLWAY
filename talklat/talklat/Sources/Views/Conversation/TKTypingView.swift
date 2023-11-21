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
    @Environment(\.modelContext) private var context
    @ObservedObject var store: TKConversationViewStore
    @FocusState var focusState: Bool
    
    @Query private var lists: [TKTextReplacement]
    @State private var matchedTextReplacement: TKTextReplacement? = nil
    let manager = TKTextReplacementManager()
    
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
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).animation(.easeInOut(duration: 1.0)),
                        removal: .move(edge: .top)
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
                        .padding(.bottom, 12)
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
                    // C10-10 텍스트필드 영역 확대 위한 modifier -> 확인필요
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.focusState = true
                        }
                    
                    customToolbar()
                        .padding(.bottom, 16)
                }
            }
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
            TKOrbitCircles(
                store: store,
                circleRenderInfos: [
                    CircleRenderInfo(x: -10, y: -4),
                    CircleRenderInfo(x: 0, y: 10),
                    CircleRenderInfo(x: 7, y: -4),
                ],
                circleColor: Color.OR5
            )
            .frame(height: 64)
            .overlay {
                Circle()
                    .foregroundStyle(Color.OR5)
                    .overlay {
                        Text("TALK")
                            .font(.headline)
                            .foregroundStyle(Color.white)
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
                            store.onShowPreviewChevronButtonTapped()
                            
                        } label: {
                            Image(systemName: "chevron.compact.up")
                                .resizable()
                                .frame(width: 32, height: 10)
                                .padding()
                                .foregroundStyle(Color.BaseBGWhite)
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
            
            Button {
                store.blockButtonDoubleTap {
                    store.onSaveConversationButtonTapped()
                }
                
            } label: {
                Text("저장")
                    .font(.headline)
                    .padding(.horizontal, 6)
                    .foregroundStyle(saveButtonTextColor())
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(saveButtonTintColor())
            .disabled(store(\.blockButtonDoubleTap))
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
    }
    
    private func customToolbar() -> some View {
        ZStack(alignment: .bottomLeading) {
            HStack(spacing: 12) {
                // MARK: Eraser button
                Button {
                    store.onEraseAllButtonTapped()
                    
                } label: {
                    Image(systemName: "eraser.fill")
                        .font(.system(size: 22))
                        .foregroundColor(focusState ? Color.BaseBGWhite : Color.GR3)
                        .padding(10)
                        .background(focusState ? Color.GR4 : Color.GR2)
                        .clipShape(Circle())
                }
                .accessibilityLabel(Text("Clear text"))
                
                if focusState {
                    // MARK: TextReplacement Button
                    if
                        let key = replacementKeyForCurrentText(),
                        let replacements = lists.first(where: {
                            $0.wordDictionary[key] != nil
                        })?.wordDictionary[key],
                        let firstReplacement = replacements.first { // 첫 번째 요소를 사용
                        
                        Button {
                            store.onTextReplaceButtonTapped(
                                with: firstReplacement,
                                key: key
                            )
                            
                        } label: {
                            Text(firstReplacement)
                                .font(.subheadline)
                                .foregroundColor(Color.BaseBGWhite)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .lineLimit(1)
                                .background {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.GR4)
                                }
                        }
                        .padding(.vertical, 4)
                        .padding(.trailing, 4)
                    }
                }
            }
            .background(focusState ? Color.GR2 : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 24))
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
        if let last = store(\.historyItems).last,
           last.type == .answer {
            return Color.OR6
        } else if !focusState {
            return Color.GR3
        } else {
            return Color.white
        }
    }
    
    private func saveButtonTintColor() -> Color {
        if let last = store(\.historyItems).last,
           last.type == .answer {
            return Color.white
        } else if !focusState {
            return Color.GR2
        } else {
            return Color.OR5
        }
    }
    
    private func cancelButtonTextColor() -> Color {
        if let last = store(\.historyItems).last,
           last.type == .answer {
            return Color.white
        } else {
            return Color.GR6
        }
    }
    
    private func cancelButtonTintColor() -> Color {
        if let last = store(\.historyItems).last,
           last.type == .answer {
            return Color.OR6
        } else {
            return Color.GR1
        }
    }
}

// MARK: 텍스트 대치 검사
extension TKTypingView {
    // 마지막 단어가 key와 일치하는 지 검사(띄어쓰기 없이 저장해야됨)
    func replacementKeyForCurrentText() -> String? {
        guard
            let lastWord = store(\.questionText)
                .split(separator: " ")
                .last?
                .lowercased() else {
            return nil
        }
        
        let sortedKeys = lists
            .flatMap { list in
                list.wordDictionary.keys
            }.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        
        return sortedKeys.first { $0.lowercased() == lastWord }
    }
}

#Preview {
    TKConversationView(store: TKConversationViewStore())
}
