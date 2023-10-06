//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

struct AWIntroView: View {
    enum RecordStatus {
        case recording
        case writing
    }
    
    @FocusState private var isFocused: Bool
    @State private var recordStatus: RecordStatus = .writing
    @State private var text: String = ""
    
    var body: some View {
        switch recordStatus {
        case .writing:
            writingView()
        case .recording:
            recordingView()
        }
    }
    
    @ViewBuilder
    private func writingView() -> some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        text = ""
                    } label: {
                        Text("전체 지우기")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // MARK: 현재 multiline placeholder 구현에 시간이 소요되고 있음
                // lofi: 한 줄 placeholder
                TextField(
                    "요구사항 입력 영역",
                    text: $text,
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
                recordStatus = .recording
            } label: {
                Text("음성 인식 전환")
            }
            
            Spacer()
                .frame(maxHeight: 120)
        }
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func recordingView() -> some View {
        VStack {
            Button {
                recordStatus = .writing
            } label: {
                Text("?")
            }
        }
    }
}

struct AWIntroView_Previews: PreviewProvider {
    static var previews: some View {
        AWIntroView()
    }
}
