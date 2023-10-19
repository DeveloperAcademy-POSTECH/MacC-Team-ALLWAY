//
//  TLTextField.swift
//  talklat
//
//  Created by 신정연 on 2023/10/14.
//

import SwiftUI

enum TLTextFieldStyle {
    case normal(textLimit: Int)
}

struct TLTextField<Button: View>: View {
    @Binding var text: String
    
    private var style: TLTextFieldStyle
    private var placeholder: String
    private var leadingButton: Button
    private let customPlaceholder: String = "탭해서 전하고 싶은 내용을 작성해주세요."
    
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
                textCountIndicator(textLimit: textLimit)
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
        .padding(.bottom, 24)
    }
    
    private func textCountIndicator(textLimit: Int) -> some View {
        HStack {
            Text("\($text.wrappedValue.count)/\(textLimit)")
                .monospacedDigit()
                .foregroundColor(
                    text.count >= textLimit
                    ? .red
                    : .gray
                )
                .padding(.leading, 24)
            
            Spacer()
        }
    }
    
    private func inputFieldSection(textLimit: Int) -> some View {
        ZStack {
            if text.isEmpty {
                HStack {
                    Text(customPlaceholder)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray)
                        .lineSpacing(180)
                        .padding(.leading, 24)
                    Spacer()
                }
            }
            TextField(
                placeholder,
                text: $text
            )
            .font(.system(size: 20, weight: .bold))
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .frame(maxWidth: .infinity)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: text) { _ in
                if text.count > textLimit {
                    text = String(text.prefix(textLimit))
                }
            }
        }
    }
}

struct TLTextFieldTestView: View {
    @State private var text = ""
    
    var body: some View {
        ZStack {
            TLTextField(
                style: .normal(textLimit: 55),
                text: $text,
                placeholder: "",
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
