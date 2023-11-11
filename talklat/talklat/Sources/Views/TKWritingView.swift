//
//  TKWritingView.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

struct TKWritingView: View {
    @ObservedObject var appViewStore: AppViewStore
    @FocusState var focusState: Bool
    @FocusState var neverFocus: Bool
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        appViewStore.questionText.count == appViewStore.questionTextLimit
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            // TODO: Upper Chevron
            if let lastItem = appViewStore.historyItems.last,
               lastItem.type == .answer {
                VStack {
                    ScrollView {
                        Text(lastItem.text)
                            .font(.title3)
                            .bold()
                            .lineSpacing(8)
                    }
                    .frame(height: 200)
                    
                    Divider()
                    
                    Image(systemName: "waveform.circle.fill")
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 40)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray.opacity(0.1))
                        .padding(.horizontal)
                }
                .padding(.top, 16)
            }
            
            TLTextField(
                style: .normal(textLimit: 160),
                text: Binding(
                    get: { appViewStore.questionText },
                    set: { appViewStore.questionTextSetter($0) }
                ),
                placeholder: "탭해서 전하고 싶은 내용을 작성해주세요.",
                leadingButton: {
                    Button {
                        appViewStore.removeQuestionTextButtonTapped()
                    } label: {
                        Text("전체 지우기")
                            .foregroundColor(
                                appViewStore.questionText.isEmpty
                                ? .gray.opacity(0.5)
                                : .gray
                            )
                    }
                    .opacity(focusState ? 1.0 : 0.0)
                }
            )
            .focused($focusState)
            .overlay(alignment: .topLeading) {
                characterLimitView()
                    .padding(.leading, 24)
                    .padding(.top, 36)
                    .opacity(focusState ? 1.0 : 0.0)
                    .animation(.easeInOut, value: focusState)
            }
            .padding(.top, 24)
            
            Spacer()
        }
        .overlay(alignment: .bottom) {
            Button {
                appViewStore.enterSpeechRecognizeButtonTapped()
                HapticManager.sharedInstance.generateHaptic(.rigidTwice)
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
            .padding(.bottom, 20)
        }
        .onAppear {
            appViewStore.onWritingViewAppear()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            // TKHistoryView로 text 전달
            appViewStore.onWritingViewDisappear()
        }
    }
    
    // MARK: - METHODS
        private func characterLimitView() -> some View {
            Text("\(appViewStore.questionText.count)/\(appViewStore.questionTextLimit)")
                .font(.system(size: 12, weight: .regular))
                .monospacedDigit()
                .foregroundColor(
                    hasQuestionTextReachedMaximumCount
                    ? .red
                    : .gray
                )
        }
}

struct TKWritingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TKWritingView(appViewStore: AppViewStore.makePreviewStore {
                instance in
                instance.answeredTextSetter("testtesttesttesttesttesttest")
                instance.historyItems.append(.init(id: .init(), text: "A long string of text that goes on an A long string of text A long string of text that goes on an A long string of text that goes on an A long string of text that goes on an ", type: .answer))
            })
        }
    }
}
