//
//  SettingTRTextField.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftUI

struct SettingTRTextField: View {
    @State private var isTextEmpty: Bool = false
    @Binding var text: String
    @FocusState var focusState: Bool
    
    var allowSpace: Bool = true // 띄어쓰기 허용 여부
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
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: text) { newValue in
                if !allowSpace && newValue.contains(" ") {
                    text = newValue.replacingOccurrences(of: " ", with: "")
                }
                if newValue.count > limit {
                    let lastCharIndex = text.index(
                        text.startIndex,
                        offsetBy: limit - 1
                    )
                    text = text.prefix(limit - 1) + String(text[lastCharIndex])
                }
                
                handleEmptyText(text)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 16)
            .background(Color.GR1)
            .cornerRadius(22)
            .safeAreaInset(edge: .bottom, content: {
                HStack {
                    characterLimitViewBuilder(currentCount: text.count, limit: limit, isTextEmpty: false)
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
        limit: Int,
        isTextEmpty: Bool
    ) -> some View {
        if !allowSpace && text.contains(" ") {
            return BDText(text: "단축어에는 띄어쓰기를 사용할 수 없어요", style: .FN_SB_135)
                .foregroundColor(Color.RED)
        }
        if currentCount == 0 {
            return BDText(text: "한 글자 이상 입력해 주세요", style: .FN_SB_135)
                .foregroundColor(Color.RED)
        } else {
            let displayCount = min(currentCount, limit)
            let countText = "\(displayCount)/\(limit)"
            let textColor: Color = currentCount >= limit ? Color.RED : Color.GR4
            return BDText(text: countText, style: .FN_SB_135)
                .foregroundColor(textColor)
        }
    }

    private func handleEmptyText(_ text: String) {
        if text == "" {
            isTextEmpty = true
        }
    }
}
