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
                    style: ._17H_B
                )
            }
            
            BDText(text: guidingMessage, style: ._34LT_EXB)
                .multilineTextAlignment(.leading)
            
            BDText(
              text: Constants.CONVERSATION_GUIDINGMESSAGE,
                style: ._22T2_B
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
