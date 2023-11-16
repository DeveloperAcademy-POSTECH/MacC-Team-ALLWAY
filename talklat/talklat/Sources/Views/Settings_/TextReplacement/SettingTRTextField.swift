//
//  SettingTRTextField.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftUI

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
            .frame(height: 44)
            .onChange(of: text) { newValue in
                if newValue.count > limit {
                    let lastCharIndex = text.index(text.startIndex, offsetBy: limit - 1)
                    text = text.prefix(limit - 1) + String(text[lastCharIndex])
                }
            }
            .padding(.horizontal, 16)
            .background(Color.GR1)
            .cornerRadius(22)
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
    
    private func characterLimitViewBuilder(currentCount: Int, limit: Int) -> some View {
        if currentCount == 0 {
            return Text(Constants.TEXTFIELD_MESSAGE)
                .foregroundColor(.red)
                .font(.system(size: 13, weight: .medium))
        } else {
            let displayCount = min(currentCount, limit)
            return Text("\(displayCount)/\(limit)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(currentCount == limit ? .red : .GR4)
        }
    }
}
