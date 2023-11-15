//
//  SettingTRTextField.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftUI

// MARK: 텍스트 대치에서 사용하는 텍스트 필드인데 Setting-안내문구 뷰에서도 사용됩니다.
struct SettingTRTextField: View {
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
            .onChange(of: text) { newValue in
                if newValue.count > limit {
                    let lastCharIndex = text.index(text.startIndex, offsetBy: limit - 1)
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
            //            .background(alignment: .bottomTrailing) {
            //                characterLimitViewBuilder(currentCount: text.count, limit: limit)
            //                    .padding(.top, 50)
            //                    .padding(.leading, 16)
            //                    .animation(.easeInOut(duration: 0.5), value: focusState)
            //            }
        }
    }
    private func characterLimitViewBuilder(currentCount: Int, limit: Int) -> some View {
        let displayCount = min(currentCount, limit)
        return Text("\(displayCount)/\(limit)")
            .font(.system(size: 13, weight: .medium))
            .monospacedDigit()
            .foregroundColor(currentCount == limit ? .accentColor : .GR4)
    }
}
