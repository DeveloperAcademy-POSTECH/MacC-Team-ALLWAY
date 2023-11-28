//
//  SettingsGuidingEditView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingEditView: View {
    @State private var hasContentChanged: Bool = false
    @State private var isTextEmpty: Bool = false
    @State private var guidingMessage: String = UserDefaults.standard.string(
        forKey: "guidingMessage"
    ) ?? String("안녕하세요. \n저는 청각장애를 \n가지고 있습니다.")
    
    private let fixedMessage: String =
        """
        해당 화면이 종료되면
        음성인식이 시작됩니다.
        제 글을 읽고 또박또박 말씀해 주세요.
        """
    
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
                    ? "안내 문구 적용화면 미리보기"
                    : "안내 문구 미리보기",
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
                title: "안내 문구",
                placeholder: "",
                limit: 30
            )
            .lineLimit(3)
            .padding(.vertical, 24)
            
            // FixedMessage Text
            VStack(alignment: .leading) {
                BDText(text: "고정 문구", style: .H2_SB_135)
                    .foregroundStyle(Color.GR5)
                    .padding(.horizontal, 16)
                
                HStack {
                    Text(fixedMessage)
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
            ToolbarItem(placement: .principal) {
                BDText(text: "안내 문구 편집", style: .H1_B_130)
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
    }
}
