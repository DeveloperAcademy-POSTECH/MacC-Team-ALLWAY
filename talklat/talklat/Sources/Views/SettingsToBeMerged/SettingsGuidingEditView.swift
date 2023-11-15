//
//  SettingsGuidingEditView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingEditView: View {
    @State private var hasContentChanged: Bool = false
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
                Text(
                    hasContentChanged
                    ? "안내 문구 적용화면 미리보기"
                    : "안내 문구 미리보기"
                )
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 17)
                    .frame(maxWidth: .infinity)
                    .background(Color.OR5)
                    .cornerRadius(22)
            }
            
            // GuidingMessage TextField
            SettingTRTextFieldToBeReplaced(
                text: $guidingMessage,
                title: "안내 문구",
                placeholder: "",
                limit: 30
            )
            .lineLimit(3)
            .padding(.vertical, 24)
            
            // FixedMessage Text
            VStack(alignment: .leading) {
                Text("고정 문구")
                    .foregroundStyle(Color.gray500)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                
                HStack {
                    Text(fixedMessage)
                        .foregroundColor(.gray400)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .background(Color.gray100)
                .cornerRadius(16)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .navigationTitle("안내 문구 편집")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: guidingMessage) { _, _ in
            hasContentChanged = true
            
            // Save guidingMessage
            UserDefaults.standard.set(
                self.guidingMessage,
                forKey: "guidingMessage"
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingEditView()
    }
}
