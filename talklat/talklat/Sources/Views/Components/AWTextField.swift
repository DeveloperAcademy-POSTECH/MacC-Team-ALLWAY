//
//  AWTextField.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

import SwiftUI

enum AWTextFieldStyle {
    case search
    case normal(textLimit: Int)
}

struct AWTextField<LabelIcon: View, TrailingButton: View>: View {
    @State private var isMaxedOut: Bool = false
    
    @Binding var text: String
    private var style: AWTextFieldStyle
    private var leadingIcon: LabelIcon
    private var trailingButton: TrailingButton
    private var placeholder: String?
    
    var body: some View {
        switch style {
        case .normal:
            TextField(
                placeholder ?? "",
                text: $text
            )
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity)
            
        case let .search:
            VStack(
                alignment: .trailing,
                spacing: 4
            ) {
                HStack {
                    leadingIcon
                    
                    TextField(
                        placeholder ?? "",
                        text: $text
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        HStack {
                            Spacer()
                            
                            trailingButton
                        }
                    }
                }
                .padding(7)
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .foregroundColor(.gray100)
                }
            }
        }
    }
    
    init(
        style: AWTextFieldStyle = .normal(textLimit: 20),
        text: Binding<String>,
        placeholder: String? = "",
        @ViewBuilder leadingIcon: () -> LabelIcon,
        @ViewBuilder trailingButton: () -> TrailingButton
    ) {
        self.style = style
        self._text = text
        self.placeholder = placeholder
        self.leadingIcon = leadingIcon()
        self.trailingButton = trailingButton()
    }
}

struct AWTextField_Celan_TestView: View {
    @State private var text1 = ""
    @State private var text2 = ""
    
    var body: some View {
        VStack {
            AWTextField(
                style: .search,
                text: $text1,
                placeholder: "title"
            ) {
                Image(systemName: "magnifyingglass.circle.fill")
            } trailingButton: {
                Button {
                    text1 = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .tint(.red)
            }
            
            AWTextField(
                style: .search,
                text: $text2,
                leadingIcon: { },
                trailingButton: { }
            )
        }
    }
}
