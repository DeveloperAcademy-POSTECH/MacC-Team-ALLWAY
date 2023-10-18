//
//  TKRecordingView.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import CoreHaptics
import SwiftUI

struct TKRecordingView: View {
    @StateObject var speechRecognizeManager: SpeechRecognizer = SpeechRecognizer()
    @ObservedObject var appViewStore: AppViewStore
    @State var historyItems: [HistoryItem] = []

    var body: some View {
        VStack {
            VStack {
                if appViewStore.questionText.isEmpty { }
                else if !appViewStore.questionText.isEmpty {
                    Text(appViewStore.questionText)
                        .font(appViewStore.communicationStatus == .recording ? .title2 : .largeTitle)
                        .bold()
                        .lineSpacing(appViewStore.communicationStatus == .recording ? 10 : 14)
                        .animation(.easeInOut, value: appViewStore.communicationStatus)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                
                if speechRecognizeManager.transcript == "" {
                    guideMessageBuilder()
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                    
                } else {
                    Text(speechRecognizeManager.transcript)
                        .font(.largeTitle)
                        .bold()
                        .lineSpacing(10)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                
                Spacer()
                
                recordButtonBuilder()
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            speechRecognizeManager.startTranscribing()
        }
        .onChange(of: appViewStore.communicationStatus) { communicationStatus in
            switch communicationStatus {
            case .recording:
                speechRecognizeManager.startTranscribing()
            case .writing:
                speechRecognizeManager.stopAndResetTranscribing()
            }
        }
        .onChange(of: speechRecognizeManager.transcript) { transcript in
            if !transcript.isEmpty {
                appViewStore.answeredTextSetter(transcript)
                print(transcript)
            }
        }
        .onDisappear {
            // TKHistoryView로 transcript 전달
            if let answeredText = appViewStore.answeredText, !answeredText.isEmpty && !speechRecognizeManager.transcript.isEmpty {
                let answerItem = HistoryItem(id: UUID(), text: answeredText, type: .answer)
                appViewStore.historyItems.append(answerItem)
            }
        }
    }
    
    private func guideMessageBuilder() -> some View {
        Text(Constants.GUIDE_MESSAGE)
            .font(.largeTitle)
            .bold()
            .kerning(2)
            .lineSpacing(10)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .foregroundColor(.gray)
    }
    
    private func recordButtonBuilder() -> some View {
        Button {
            appViewStore.stopSpeechRecognizeButtonTapped()
        } label: {
            Image(systemName: "square.fill")
                .foregroundColor(.white)
                .padding()
        }
        .background {
            Circle()
                .foregroundColor(.gray)
        }
    }
}

struct TKRecordingView_Previews: PreviewProvider {
    @State static var showHistoryView: Bool = false
    
    static var previews: some View {
        TKRecordingView(
            appViewStore: AppViewStore.makePreviewStore { instance in
                instance.communicationStatusSetter(.recording)
                instance.questionTextSetter("""
                일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오
                """)
            }
        )
    }
}
