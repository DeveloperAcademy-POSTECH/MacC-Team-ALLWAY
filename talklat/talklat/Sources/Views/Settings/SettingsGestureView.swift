//
//  SettingsGestureView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

struct SettingsGestureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isGestureEnabled: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            BDText( // TODO: 섹션 타이틀 TKListCell로 이동
                text: "대화 전환",
                style: ._15H2_SMB
            )
            .foregroundColor(.GR5)
            .padding(.leading, 16)
            
            BDListCell(label: "플립 제스처") {
                } trailingUI: {
                    Toggle("", isOn: $isGestureEnabled)
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
        .onAppear {
            isGestureEnabled = UserDefaults.standard.bool(
                forKey: "isGestureEnabled"
            )
        }
        .onChange(of: isGestureEnabled) { _, _ in
            UserDefaults.standard.setValue(
                isGestureEnabled,
                forKey: "isGestureEnabled"
            )
        }
    }
}

#Preview {
    SettingsGestureView()
}
