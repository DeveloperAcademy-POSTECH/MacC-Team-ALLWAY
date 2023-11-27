//
//  SettingTRTextField.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftUI

// TODO: - SettingTRTextField와 합치기 (isTextEmpty 추가되는 스타일로 분리)
struct SettingTextField: View {
    @Binding var  isTextEmpty: Bool
    @Binding var text: String
    @FocusState var focusState: Bool
    
    var title: String
    var placeholder: String
    var limit: Int
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                BDText(text: title, style: .H2_SB_135)
                    .foregroundStyle(Color.GR5)
                    .padding(.horizontal, 16)
                Spacer()
            }
            
            TextField(
                placeholder,
                text: $text,
                axis: .vertical
            )
            .onChange(of: text) { newValue in
                if newValue.count > limit {
                    let lastCharIndex = text.index(
                        text.startIndex,
                        offsetBy: limit - 1
                    )
                    text = text.prefix(limit - 1) + String(text[lastCharIndex])
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(Color.GR1)
            .cornerRadius(16)
            .safeAreaInset(edge: .bottom, content: {
                HStack {
                    characterLimitViewBuilder(currentCount: text.count, limit: limit)
                        .animation(.easeInOut(duration: 0.5), value: focusState)
                        .padding(.leading, 16)
                        .padding(.top, 3)
                    
                    Spacer()
                }
            })
        }
    }
    
    private func characterLimitViewBuilder(
        currentCount: Int,
        limit: Int
    ) -> some View {
        let displayCount = min(currentCount, limit)
        return BDText(text: "\(displayCount)/\(limit)", style: .FN_M_135)
            .monospacedDigit()
            .foregroundColor(
                currentCount == limit || isTextEmpty
                ? .RED
                : .GR7
            )
    }
}
