//
//  TKTextReplacementAddView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementAddView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var settingStore: SettingViewStore
    @Environment(\.presentationMode) var presentationMode
    var isInputValid: Bool {
        !phrase.isEmpty && !replacement.isEmpty
    }
    @FocusState var focusState: Bool
    @State private var phrase: String = ""
    @State private var replacement: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                SettingTRTextField (
                    title: "단축 문구",
                    placeholder: "아아",
                    limit: 20,
                    text: $phrase,
                    focusState: _focusState
                )
                SettingTRTextField (
                    title: "변환 문구",
                    placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                    limit: 160,
                    text: $replacement
                )
                .padding(.top, 36)
                
                Spacer()
            }
            .padding()
            .navigationTitle("텍스트 대치 추가")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(action: {
                    if isInputValid {
                        // TKTextReplacement 객체를 적절한 인자로 생성합니다.
                        let newReplacement = TKTextReplacement(wordDictionary: [phrase: [replacement]])
                        // context에 새 객체를 추가하고 저장합니다.
                        context.insert(newReplacement)
                        try? context.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("완료")
                }
                .disabled(!isInputValid)
                .foregroundColor(isInputValid ? .accentColor : .gray400)
            )
        }
    }
}


struct TKTextReplacementAddView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        TKTextReplacementAddView()
    }
}
