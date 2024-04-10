//
//  SettingsGuidingEditView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var hasContentChanged: Bool = false
    @State private var isTextEmpty: Bool = false
    @State private var guidingMessage: String = UserDefaults.standard.string(
        forKey: "guidingMessage"
    ) ?? NSLocalizedString("settings.guiding.edit.defaultGuidingMessage", comment: "")

    private let fixedMessage: String = NSLocalizedString("settings.guiding.edit.fixedMessage", comment: "")
//    private let fixedMessage: String =
//        """
//        해당 화면이 종료되면
//        음성인식이 시작됩니다.
//        제 글을 읽고 또박또박 말씀해 주세요.
//        """

    var body: some View {
        VStack {
            // Show GuidingView Button
            NavigationLink {
                SettingsGuidingPreView(
                    guidingMessage: $guidingMessage
                )
            } label: {
                BDText(
                    text: hasContentChanged
                    ? NSLocalizedString("settings.guiding.edit.previewButton.changed", comment: "")
                    : NSLocalizedString("settings.guiding.edit.previewButton", comment: ""),
                    style: .H1_B_130
                )
                .foregroundColor(.white)
                .padding(.vertical, 17)
                .frame(maxWidth: .infinity)
                .background(
                    isTextEmpty
                    ? Color.GR3
                    : Color.OR5
                )
                .cornerRadius(22)
            }
            .disabled(isTextEmpty)
            
            // GuidingMessage TextField
            SettingTextField(
                isTextEmpty: $isTextEmpty,
                text: $guidingMessage,
                title: NSLocalizedString("settings.guiding.edit.title", comment: ""),
                placeholder: NSLocalizedString("settings.guiding.edit.placeholder", comment: ""),
                limit: 30
            )
            .lineLimit(3)
            .padding(.vertical, 24)
            
            // FixedMessage Text
            VStack(alignment: .leading) {
                BDText(text: NSLocalizedString("settings.guiding.edit.fixedMessage.title", comment: ""), style: .H2_SB_135)
                    .foregroundStyle(Color.GR5)
                    .padding(.horizontal, 16)
                
                HStack {
                    Text(Constants.CONVERSATION_GUIDINGMESSAGE)
                        .foregroundColor(.GR4)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .background(Color.GR1)
                .cornerRadius(16)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: NSLocalizedString(
                                "settings.guiding.title",
                                comment: ""
                            ),
                               style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: NSLocalizedString(
                    "settings.guiding.edit",
                    comment: ""
                ), style: .H1_B_130)
            }
        }
        .onChange(of: guidingMessage) { _, _ in
            hasContentChanged = true
            
            // Save guidingMessage
            if guidingMessage != "" {
                UserDefaults.standard.set(
                    self.guidingMessage,
                    forKey: "guidingMessage"
                )
                isTextEmpty = false
            } else {
                isTextEmpty = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingEditView()
            .navigationBarTitleDisplayMode(.inline)
    }
}
