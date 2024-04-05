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
        VStack(alignment: .leading, spacing: 20) {
            Button {
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
                text: NSLocalizedString("settings.guiding.edit.fixedMessage", comment: ""),
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
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingPreView(guidingMessage: .constant("ddd"))
    }
}
