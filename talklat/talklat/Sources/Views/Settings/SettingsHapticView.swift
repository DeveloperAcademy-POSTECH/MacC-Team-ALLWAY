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
            BDText(text: "기본", style: ._15H2_SMB) // TODO: 섹션 타이틀 TKListCell로 이동
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
                            text: NSLocalizedString("설정", comment: ""),
                            style: ._17H_B
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: "진동", style: ._17H_B)
            }
        }
        .background(Color.ExceptionWhiteW8)
    }
}

#Preview {
    NavigationStack {
        SettingsHapticView()
    }
}
