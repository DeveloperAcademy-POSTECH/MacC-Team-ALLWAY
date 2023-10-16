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
    
    private var hasQuestionTextReachedMaximumCount: Bool {
        appViewStore.questionText.count == appViewStore.questionTextLimit
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            VStack {                
                if let answeredText = appViewStore.answeredText {
                    Text(answeredText)
                        .font(.headline)
                        .bold()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 100,
                            alignment: .leading
                        )
                        .padding(.top, 40)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 80)
                }
                
                HStack {
                    Button {
                        appViewStore.removeQuestionTextButtonTapped()
                    } label: {
                        Text("전체 지우기")
                            .foregroundColor(.gray)
                    }
                    .font(.headline)
                    .padding(.leading, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                    .disabled(appViewStore.questionText.isEmpty)
                    
                    Spacer()
                }
                .opacity(focusState ? 1.0 : 0.0)
                .animation(.easeInOut, value: focusState)
                
                // MARK: Multiline Placeholder 구현 불가
                // lofi: 한 줄만 보이는 placeholderㅠㅠ
                TKTextField(appViewStore: appViewStore)
                    .focused($focusState)
                    .overlay(alignment: .topLeading) {
                        characterLimitView()
                            .padding(.leading, 24)
                            .opacity(focusState ? 1.0 : 0.0)
                            .animation(.easeInOut, value: focusState)
                    }
            }
            
            Spacer()
            
            Button {
                appViewStore.enterSpeechRecognizeButtonTapped()
            } label: {
                Text("**음성 인식 전환**")
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background {
                Capsule()
                    .foregroundColor(.gray)
            }
            
            Spacer()
                .frame(maxHeight: 60)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            appViewStore.onWritingViewAppear()
        }
    }
    
    // MARK: - METHODS
    private func characterLimitView() -> some View {
        Text("\(appViewStore.questionText.count)/\(appViewStore.questionTextLimit)")
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
        TKWritingView(
            appViewStore: AppViewStore.makePreviewStore { instance in
                instance.questionTextSetter("Test")
            }
        )
    }
}
