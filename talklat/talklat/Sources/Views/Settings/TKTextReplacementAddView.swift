//
//  TKTextReplacementAddView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementAddView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settingStore: SettingViewStore
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState var focusState: Bool
    @State private var phrase: String = ""
    @State private var replacement: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                SettingTRTextField(title: "단축 문구", placeholder: "아아", limit: 20, text: $phrase, focusState: _focusState)
                SettingTRTextField(title: "변환 문구", placeholder: "아이스 아메리카노 한 잔 주시겠어요?", limit: 160, text: $replacement)
                    .padding(.top, 36)
                
                Spacer()
            }
            .padding()
            .navigationTitle("텍스트 대치 추가")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("취소") {
//                settingStore.closeTextReplacementAddView()
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarItems(trailing: Button("완료") {
                let newItem = TKTextReplacement(wordDictionary: [phrase: replacement])
                context.insert(newItem)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func characterLimitViewBuilder(currentCount: Int, limit: Int) -> some View {
        let displayCount = min(currentCount, limit)
        return Text("\(displayCount)/\(limit)")
            .font(.system(size: 13, weight: .medium))
            .monospacedDigit()
            .foregroundColor(.gray400)
    }
}


struct TKTextReplacementAddView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        TKTextReplacementAddView()
    }
}
