//
//  TLTextField.swift
//  talklat
//
//  Created by 신정연 on 2023/10/14.
//

import SwiftUI

enum TLTextFieldStyle {
    case normal(textLimit: Int)
    case typing(textLimit: Int)
}

struct TLTextField<Button: View>: View {
    @Binding var text: String
    
    private var style: TLTextFieldStyle
    private var placeholder: String
    private var leadingButton: Button
    
    init(
        style: TLTextFieldStyle,
        text: Binding<String>,
        placeholder: String,
        @ViewBuilder leadingButton: () -> Button
    ){
        self.style = style
        self._text = text
        self.placeholder = placeholder
        self.leadingButton = leadingButton()
    }
    
    var body: some View {
        switch style {
        case let .normal(textLimit):
            VStack {
                leadingButtonSection
                inputFieldSection(textLimit: textLimit)
            }
        case let .typing(textLimit):
            VStack {
                inputFieldSection(textLimit: textLimit)
            }
        }
    }
    
    private var leadingButtonSection: some View {
        HStack {
            leadingButton
                .padding(.leading, 24)
            
            Spacer()
        }
        .padding(.bottom, 32)
    }
    
    private func inputFieldSection(textLimit: Int) -> some View {
        
        TextField(
            placeholder,
            text: $text,
            axis: .vertical
        )
        .font(.custom("Pretendard", size: 20))
        .lineSpacing(20 * 1.6 - 20)
        .bold()
        .lineLimit(5, reservesSpace: true)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .onChange(of: text) { _, _ in
            if text.count > textLimit {
                text = String(text.prefix(textLimit))
            }
        }
        
    }
}

struct TLTextFieldTestView: View {
    @State private var text = ""
    
    var body: some View {
        ZStack {
            TLTextField(
                style: .normal(textLimit: 160),
                text: $text,
                placeholder: "탭해서 전하고 싶은 내용을 작성해주세요.",
                leadingButton: {
                    Button {
                        text = ""
                    } label: {
                        Text("전체 지우기")
                            .foregroundColor(.gray)
                    }
                }
            )
        }
    }
}

struct TLTextField_Previews: PreviewProvider {
    static var previews: some View {
        TLTextFieldTestView()
    }
}
