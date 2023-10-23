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
            // (Test용) TKHistoryView로 이동하는 부분
            // TODO: Upper Chevron
            
            if let answeredText = appViewStore.answeredText {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2)
                        .foregroundStyle(.gray.opacity(0.1))
                    
                    HStack {
                        Image(systemName: "waveform.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(.systemGray))
                            .padding(.top, 24)
                            .padding(.leading, 40)
                            .transition(
                                .move(edge: .bottom)
                                .combined(with: .opacity)
                            )
                        
                        Spacer()
                    }
                    
                    Text("        " + answeredText)
                        .font(.headline)
                        .bold()
                        .lineSpacing(10)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.top, 24)
                        .padding(.horizontal, 40)
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                }
                
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
                }
            )
            .padding(.top, 24)
            
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
}

struct TKWritingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollContainer(appViewStore: AppViewStore.makePreviewStore {
                instance in
                instance.questionTextSetter("test")
                instance.historyItems.append(.init(id: .init(), text: "dfdf", type: .answer))
                instance.historyItems.append(.init(id: .init(), text: "sdf", type: .question))
            })
        }
    }
}
