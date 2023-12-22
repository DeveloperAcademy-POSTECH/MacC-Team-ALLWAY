//
//  SettingsHapticView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

struct SettingsHapticView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isHapticEnabled: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            BDText(text: "기본", style: .H2_SB_135) // TODO: 섹션 타이틀 TKListCell로 이동
                .foregroundColor(.GR5)
                .padding(.leading, 16)
            
            BDListCell(label: "진동") {
                } trailingUI: {
                    Toggle("", isOn: $isHapticEnabled)
                }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "설정",
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: "진동", style: .H1_B_130)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsHapticView()
    }
}
