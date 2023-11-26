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
    @Environment(\.presentationMode) var presentationMode
    
    private var dataStore: TKSwiftDataStore = TKSwiftDataStore()
    
    @FocusState var focusState: Bool
    @State private var phrase: String = ""
    @State private var replacement: String = ""
    
    var isInputValid: Bool {
        !phrase.isEmpty && !replacement.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                SettingTRTextField (
                    text: $phrase,
                    focusState: _focusState,
                    title: "단축 문구",
                    placeholder: "아아",
                    limit: 20
                )
                .onChange(of: phrase) { newValue in
                    if newValue.hasPrefix(" ") {
                        phrase = String(newValue.dropFirst())
                    }
                }
                
                SettingTRTextField (
                    text: $replacement, title: "변환 문구",
                    placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                    limit: 160
                )
                .padding(.top, 36)
                .onChange(of: replacement) { newValue in
                    if newValue.hasPrefix(" ") {
                        replacement = String(newValue.dropFirst())
                    }
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        BDText(
                            text: "취소",
                            style: .H1_B_130
                        )
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    BDText(
                        text: "텍스트 대치 추가",
                        style: .H1_B_130
                    )
                }
                
                ToolbarItem(placement: .automatic) {
                    Button {
                        if isInputValid {
                            dataStore.createTextReplacement(
                                phrase: phrase,
                                replacement: replacement
                            )
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        BDText(
                            text: "완료",
                            style: .H1_B_130
                        )
                    }
                    .disabled(!isInputValid)
                    .foregroundColor(isInputValid ? .OR6 : .GR4)
                }
            }
            .background(Color.SheetBGWhite)
        }
    }
}

struct TKTextReplacementAddView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        TKTextReplacementAddView()
    }
}
