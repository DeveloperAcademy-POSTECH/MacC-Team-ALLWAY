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
                firebaseStore.userDidAction(.tapped(.close))
                dismiss()
            } label: {
                BDText(
                    text: NSLocalizedString("취소", comment: ""),
                    style: .H1_B_130
                )
            }
            
            BDText(text: guidingMessage, style: .LT_B_160)
                .multilineTextAlignment(.leading)
            
            BDText(
              text: Constants.CONVERSATION_GUIDINGMESSAGE,
                style: .T2_B_160
            )
            
            Spacer()
                .frame(maxWidth: .infinity)
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
            .navigationBarTitleDisplayMode(.inline)
    }
}
