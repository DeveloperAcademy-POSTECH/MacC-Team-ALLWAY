//
//  TKTestField.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

// TODO: IT IS NOT DESIGN SYSTEM
struct TKTextField: View {
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        TextField(
            Constants.TEXTFIELD_PLACEHOLDER,
            // Text Limit, State Capsulize를 위한 Custom Binding
            text: Binding(
                get: { appViewStore.questionText },
                set: { appViewStore.bindingTextField($0) }
            ),
            prompt: Text(Constants.TEXTFIELD_PLACEHOLDER)
                .bold(),
            axis: .vertical
        )
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .lineSpacing(10)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .frame(
            maxHeight: 250,
            alignment: .topLeading
        )
        .font(.largeTitle)
        .bold()
        .multilineTextAlignment(.leading)
    }
}

struct TKTextField_Previews: PreviewProvider {
    static var previews: some View {
        TKTextField(appViewStore: .makePreviewStore { instance in
            instance.communicationStatusSetter(.writing)
            instance.questionTextSetter("")
        })
    }
}
