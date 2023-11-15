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
            Text("대화 전환") // TODO: 섹션 타이틀 TKListCell로 이동
                .foregroundColor(.GR5)
                .font(.system(size: 15, weight: .semibold))
                .padding(.leading, 16)
            
            TKListCell(label: "플립 제스처") {
                } trailingUI: {
                    Toggle("", isOn: $isGestureEnabled)
                }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .navigationTitle("진동")
        .navigationBarTitleDisplayMode(.inline)

    }
}

#Preview {
    SettingsGestureView()
}
