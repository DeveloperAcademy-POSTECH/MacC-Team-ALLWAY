//
//  HandlingTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/05.
//

import SwiftUI

struct HandlingTestingView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 50) {
            HStack(alignment: .top, spacing: 20) {
                Button("음성인식 시작") {
                    startScrum()
                    print("convertedText: ", speechRecognizer.transcript)
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
                
                Button("음성인식 종료") {
                    endScrum()
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
                .tint(.red)
            }
            .padding(.top, 40)
            
            /// 인식 내용
            Text(speechRecognizer.transcript)
                .font(.largeTitle)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
    
    private func startScrum() {
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endScrum() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}

struct HandlingTestingView_Previews: PreviewProvider {
    static var previews: some View {
        HandlingTestingView()
    }
}
