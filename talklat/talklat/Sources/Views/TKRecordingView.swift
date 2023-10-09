//
//  TKRecordingView.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

struct TKRecordingView: View {
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        VStack {
            if appViewStore.questionText.isEmpty {
                VStack {
                    guideMessageBuilder()
                    
                    Spacer()
                    
                    recordButtonBuilder()
                        .padding(.bottom, 60)
                }
            } else {
                VStack {
                    Text(appViewStore.questionText)
                        .font(.largeTitle)
                        .bold()
                        .kerning(2)
                        .lineSpacing(10)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    
                    Spacer()
                    
                    guideMessageBuilder()
                        .padding(.bottom, 90)
                    
                    recordButtonBuilder()
                        .padding(.bottom, 60)
                        
                }
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
