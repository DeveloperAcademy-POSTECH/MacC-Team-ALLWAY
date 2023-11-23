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
    
    var title: String
    var placeholder: String
    var limit: Int
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .foregroundStyle(Color.GR5)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
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
        if isTextEmpty {
            return Text("한 글자 이상 입력해 주세요")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.RED)
        } else {
            let displayCount = min(currentCount, limit)
            return Text("\(displayCount)/\(limit)")
                .font(.system(size: 13, weight: .medium))
                .monospacedDigit()
                .foregroundColor(
                    currentCount >= limit
                    ? Color.GR7
                    : Color.GR4
                )
        }
    }

    private func handleEmptyText(_ text: String) {
        if text == "" {
            isTextEmpty = true
        }
    }
}
