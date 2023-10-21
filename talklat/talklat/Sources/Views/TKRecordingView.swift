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
        ZStack {
            VStack {
                HStack {
                    // 가이드 메세지 -> 이전 유저의 질문 텍스트가 있고 & 음성 인식이 시작되면 질문 텍스트로 변경
                    if (!appViewStore.questionText.isEmpty && checkisRecording()) {
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
                        //TODO: transition? animation!
                    } else {
                        guideMessageBuilder()
                    }
                    Spacer()
                }
                
                // 이전 화면의 유저의 질문 텍스트가 있을 때에만 표시
                if (!appViewStore.questionText.isEmpty && !checkisRecording()) {
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
                        .animation(.easeInOut(duration: 0.5), value: checkisRecording())
                }
                Spacer()
                // 음성 인식 텍스트
                if(checkisRecording()) {
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
                            .lineSpacing(12)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 100)//ㅠㅠ
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
            
            #if DEBUG
            if !ProcessInfo.processInfo.environment.keys.contains("XCODE_RUNNING_FOR_PREVIEWS") {
                speechRecognizeManager.startTranscribing()
            }
            #endif
        }
//        .onAppear {
//            appViewStore.onRecordingViewAppear()
//            speechRecognizeManager.startTranscribing()
//        }
        .onChange(of: appViewStore.communicationStatus) { communicationStatus in
            #if DEBUG
            if !ProcessInfo.processInfo.environment.keys.contains("XCODE_RUNNING_FOR_PREVIEWS") {
                switch communicationStatus {
                case .recording:
                    speechRecognizeManager.startTranscribing()
                case .writing:
                    speechRecognizeManager.stopAndResetTranscribing()
                }
            }
            #endif
        }

//        .onChange(of: appViewStore.communicationStatus) { communicationStatus in
//            switch communicationStatus {
//            case .recording:
//                speechRecognizeManager.startTranscribing()
//            case .writing:
//                speechRecognizeManager.stopAndResetTranscribing()
//            }
//        }
        .onChange(of: speechRecognizeManager.transcript) { transcript in
            if !transcript.isEmpty {
                appViewStore.answeredTextSetter(transcript)
                print(transcript)
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
    
    private func checkisRecording() -> Bool {
        if speechRecognizeManager.transcript != "" {
            return true
        } else {
            return false
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
