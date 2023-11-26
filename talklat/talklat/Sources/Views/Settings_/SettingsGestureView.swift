//
//  SettingsGestureView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

struct SettingsGestureView: View {
    @State private var isGestureEnabled: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            BDText( // TODO: 섹션 타이틀 TKListCell로 이동
                text: "대화 전환",
                style: .H2_SB_135
            )
            .foregroundColor(.GR5)
            .padding(.leading, 16)
            
            TKListCell(label: "플립 제스처") {
                } trailingUI: {
                    Toggle("", isOn: $isGestureEnabled)
                }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .principal) {
                BDText(text: "진동", style: .H1_B_130)
            }
        }


    }
}

#Preview {
    SettingsGestureView()
}
