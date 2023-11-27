//
//  SettingsGuidingPreView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingPreView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var guidingMessage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Text("취소")
                    .font(.headline)
                    .bold()
            }
            
            Spacer()
                .frame(maxHeight: 60)
            
            Text(guidingMessage)
                .font(.largeTitle)
                .bold()
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .padding(.top, 20)
                .padding(.bottom, 40)
            
            Text("해당 화면이 종료되면 \n음성인식이 시작됩니다. \n제 글을 읽고 또박또박 말씀해 주세요."
            )
            .font(.title2)
            .bold()
            
            Spacer()
            
        }
        .foregroundColor(.BaseBGWhite)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding(.horizontal, 24)
        .background(Color.OR5)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingPreView(guidingMessage: .constant("ddd"))
    }
}
