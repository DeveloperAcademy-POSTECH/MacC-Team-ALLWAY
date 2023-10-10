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
    
    var body: some View {
        VStack {
            if appViewStore.questionText.isEmpty {
                VStack {
                    if speechRecognizeManager.transcript == "" {
                        guideMessageBuilder()
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
            } else {
                VStack {
                    Text(appViewStore.questionText)
                        .font(.largeTitle)
                        .bold()
                        .lineSpacing(10)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    
                    Spacer()
                    
                    if speechRecognizeManager.transcript == "" {
                        guideMessageBuilder()
                            .padding(.bottom, 90)
                    } else {
                        Text(speechRecognizeManager.transcript)
                            .font(.largeTitle)
                            .lineSpacing(10)
                            .padding(.bottom, 90)
                    }
                    
                    recordButtonBuilder()
                        .padding(.bottom, 60)
                }
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
            appViewStore.answeredTextSetter(transcript)
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