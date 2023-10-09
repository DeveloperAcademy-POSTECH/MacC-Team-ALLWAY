//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

struct TKIntroView: View {
    @StateObject private var appViewManager: AppViewManager = .init()
    
    var body: some View {
        switch appViewManager.communicationStatus {
        case .writing:
            WritingView(appViewManager: appViewManager)
        case .recording:
            
            VStack {
                Text(appViewManager.communicationStatus.rawValue)
                
                Button {
                    appViewManager.communicationStatus = .writing
                } label: {
                    Text("Toggle")
                }
            }
        }
    }
}

struct AWIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKIntroView()
    }
}

struct WritingView: View {
    @ObservedObject var appViewManager: AppViewManager
    
    var body: some View {
        VStack {
            VStack {
                Text("\(appViewManager.communicationStatus.rawValue)")
                
                HStack {
                    Button {
                        appViewManager.text = ""
                    } label: {
                        Text("전체 지우기")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // MARK: Multiline Placeholder 구현 불가
                // lofi: 한 줄 placeholder
                TextField(
                    "요구사항 입력 영역",
                    text: $appViewManager.text,
                    prompt: Text("내용을 입력하세요"),
                    axis: .vertical
                )
                .padding()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(
                    maxHeight: 150,
                    alignment: .topLeading
                )
                .font(.title)
                .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Button {
                appViewManager.communicationStatus = .recording
            } label: {
                Text("음성 인식 전환")
            }
            
            Spacer()
                .frame(maxHeight: 120)
        }
        .frame(maxHeight: .infinity)
    }
}
