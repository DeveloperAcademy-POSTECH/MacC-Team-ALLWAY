//
//  SettingsGuidingPreView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingPreView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var guidingMessage: String
    
    let firebaseStore: any TKFirebaseStore = SettingsGuideMessagePreviewFirebaseStore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                firebaseStore.userDidAction(
                    .tapped,
                    "cancel",
                    nil
                )
                dismiss()
            } label: {
                BDText(
                    text: "취소",
                    style: .H1_B_130
                )
            }
            
            BDText(text: guidingMessage, style: .LT_B_160)
                .multilineTextAlignment(.leading)
            
            BDText(
                text: "해당 화면이 종료되면 \n음성인식이 시작됩니다. \n제 글을 읽고 또박또박 말씀해 주세요.",
                style: .T2_B_160
            )
            
            Spacer()
        }
        .foregroundColor(.white)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding(.horizontal, 24)
        .background(Color.OR5)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingPreView(guidingMessage: .constant("ddd"))
    }
}
