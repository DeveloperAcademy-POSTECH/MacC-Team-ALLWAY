//
//  StaffSpeechView.swift
//  talklat
//
//  Created by 신정연 on 2023/10/05.
//
import SwiftUI
import AVFoundation

struct StaffSpeechView: View {

    @StateObject var speechRecognizer = SpeechRecognizer()
    @Binding var userRequest: String
    
    // test용이라 나중에 지우기
    init(userRequest: Binding<String> = .constant("아이스아메리카노 큰 사이즈 주세여")) {
        self._userRequest = userRequest
    }
    
    var body: some View {
        ZStack {
            VStack {
                //MARK: 유저가 입력하는 텍스트
                Text(userRequest)
                    .fontWeight(.regular)
                
                Spacer()
                //MARK: 상대방의 음성 -> 텍스트
                Text(speechRecognizer.transcript)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("초기화") {
                    speechRecognizer.stopAndResetTranscribing()
                    speechRecognizer.startTranscribing()
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
                
                Spacer()
                
                VStack{
                    Image(systemName: "waveform.circle.fill")
                        .padding(.bottom, 30)
                    Text("저는 청각장애가 있어요.\n음성 인식을 위해 천천히 크게 말해주세요.")
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .onAppear {
            startSpeechRecognizer()
        }
        .onDisappear {
            endSpeechRecognizer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startSpeechRecognizer() {
        speechRecognizer.startTranscribing()
    }
    
    private func endSpeechRecognizer() {
        speechRecognizer.stopAndResetTranscribing()
    }
}

struct StaffSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        StaffSpeechView()
    }
}
