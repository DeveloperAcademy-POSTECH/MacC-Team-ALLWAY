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
        ZStack {
            VStack {
                HStack {
                    // 가이드 메세지 -> 이전 유저의 질문 텍스트가 있고 & 음성 인식이 시작되면 질문 텍스트로 변경
                    if (!appViewStore.questionText.isEmpty && isRecording) {
                        Text(appViewStore.questionText)
                            .font(.system(size: 17, weight: .medium))
                            .lineSpacing(10)
                            .animation(.easeInOut, value: appViewStore.communicationStatus)
                            .padding(.horizontal, 24)
                            .padding(.top, 78)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        //TODO: <이전 화면의 유저 질문 텍스트> 위치 이동 animation!
                    } else {
                        guideMessageBuilder()
                    }
                    Spacer()
                }
                
                // 이전 화면의 유저의 질문 텍스트가 있을 때에만 표시
                if (!appViewStore.questionText.isEmpty && !isRecording) {
                    // 유저의 질문 텍스트
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
                
                Spacer()
                // 음성 인식 텍스트
                if(isRecording) {
                    ZStack {
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
                                .foregroundStyle(.gray.opacity(0.1))
                        }
                        Text(speechRecognizeManager.transcript)
                            .font(.system(size: 24))
                            .bold()
                            .lineSpacing(14)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            VStack {
                Spacer()
                recordButtonBuilder()
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            appViewStore.onRecordingViewAppear()
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
            }
        }
        .onDisappear {
            // TKHistoryView로 transcript 전달
            appViewStore.onRecordingViewDisappear(transcript: speechRecognizeManager.transcript)
        }
    }
    
    private func guideMessageBuilder() -> some View {
        Text(Constants.GUIDE_MESSAGE)
            .font(.system(size: 24, weight: .medium))
            .multilineTextAlignment(.leading)
            .lineSpacing(12)
            .padding(.horizontal, 24)
            .padding(.top, 78)
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
                아아
                """)
            }
        )
    }
}
