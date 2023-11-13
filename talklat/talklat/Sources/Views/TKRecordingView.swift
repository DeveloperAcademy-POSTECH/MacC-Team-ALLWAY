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
    
    private var isRecording: Bool {
        return !speechRecognizeManager.transcript.isEmpty
    }
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // 가이드 메세지 -> 이전 유저의 질문 텍스트가 있고 & 음성 인식이 시작되면 질문 텍스트로 변경
                if !appViewStore.questionText.isEmpty && isRecording {
                    Text(appViewStore.questionText)
                        .font(.headline)
                        .lineSpacing(10)
                        .animation(.easeInOut, value: appViewStore.communicationStatus)
                    //TODO: <이전 화면의 유저 질문 텍스트> 위치 이동 animation!
                    
                } else {
                    guideMessageBuilder()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            
            // 이전 화면의 유저의 질문 텍스트가 있을 때에만 표시
            if !appViewStore.questionText.isEmpty && !isRecording {
                // 유저의 질문 텍스트
                Text(appViewStore.questionText)
                    .font(
                        appViewStore.communicationStatus == .recording
                        ? .title2
                        : .largeTitle
                    )
                    .bold()
                    .lineSpacing(
                        appViewStore.communicationStatus == .recording
                        ? 10
                        : 14
                    )
                    .animation(
                        .easeInOut,
                        value: appViewStore.communicationStatus
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            
            Spacer()
            
            if isRecording {
                Rectangle()
                    .fill(Color.gray100)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * 0.55
                    )
                    .overlay(alignment: .topLeading) {
                        Text(speechRecognizeManager.transcript)
                            .font(.system(size: 24))
                            .bold()
                            .lineSpacing(14)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .multilineTextAlignment(.leading)
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                    }
            }
        }
        .overlay(alignment: .bottom) {
            recordButtonBuilder()
                .padding(.bottom, 40)
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            self.hideKeyboard()
            appViewStore.onRecordingViewAppear()
            speechRecognizeManager.startTranscribing()
        }
        .onChange(of: appViewStore.communicationStatus) { communicationStatus in
            switch communicationStatus {
            case .recording:
                speechRecognizeManager.startTranscribing()
                appViewStore.recognitionCount += 1
            case .writing:
                speechRecognizeManager.stopAndResetTranscribing()
                appViewStore.onRecordingViewDisappear()
            }
        }
        .onChange(of: speechRecognizeManager.transcript) { transcript in
            if !transcript.isEmpty {
                appViewStore.answeredTextSetter(transcript)
                HapticManager.sharedInstance.generateHaptic(.light(times: countLastWord(transcript)))
            }
        }
        .onAppear {
            speechRecognizeManager.startTranscribing()
            print("startTranscribing() called from onAppear")
        }
    }
    
    private func guideMessageBuilder() -> some View {
        let message: String
        if appViewStore.recognitionCount == 0 {
            message = Constants.GUIDE_MESSAGE
        } else {
            message = Constants.SECOND_GUIDE_MESSAGE
        }
        
        return Text(message)
            .font(.system(size: 24, weight: .medium))
            .multilineTextAlignment(.leading)
            .lineSpacing(12)
            .foregroundColor(.gray)
    }
    
    private func recordButtonBuilder() -> some View {
        Button {
            appViewStore.stopSpeechRecognizeButtonTapped()
            HapticManager.sharedInstance.generateHaptic(.rigidTwice)
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
    
    private func countLastWord(_ transcript: String) -> Int {
        return transcript.components(separatedBy: " ").last?.count ?? 0
    }
}

struct TKRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        TKRecordingView(
            appViewStore: AppViewStore()
        )
    }
}
