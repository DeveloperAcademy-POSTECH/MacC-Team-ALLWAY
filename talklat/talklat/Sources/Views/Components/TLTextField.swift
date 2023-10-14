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
    @State private var isLetterExceeded: Bool = false
    @Binding var text: String
    
    private var style: TLTextFieldStyle
    private var placeholder: String
    private var eraseAllButton: Button
    
    
    init(
        style: TLTextFieldStyle = .normal(textLimit: 55),
        text: Binding<String>,
        placeholder: String,
        @ViewBuilder eraseAllButton: () -> Button
    ){
        self.style = style
        self._text = text
        self.placeholder = placeholder
        self.eraseAllButton = eraseAllButton()
    }
    var body: some View {
        switch style {
        case let .normal(textLimit):
            VStack {
                HStack {
                    eraseAllButton
                        .padding(.leading, 24)
                    Spacer()
                }
                .padding(.bottom, 24)
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
                ZStack {
                    HStack {
                        Text(text.count == 0 ? "상대방에게 보여주고 싶은 내용을 작성해 주세요." : "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                            .lineSpacing(24 * 0.8)
                            .padding(.leading, 24)
                            .padding(.bottom, 48)
                        Spacer()
                    }
                    
                    HStack {
                        TextField(
                            placeholder,
                            text: $text
                        )
                        .font(.system(size: 24, weight: .bold))
                        .padding(.leading, 24)
                        .padding(.bottom, 96)
                        .frame(maxWidth: .infinity)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: text) { _ in
                            if text.count > textLimit {
                                text = String(text.prefix(textLimit))
                                isLetterExceeded = true
                            }
                            else {
                                isLetterExceeded = false
                            }
                        }
                    }
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
                eraseAllButton: {
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
