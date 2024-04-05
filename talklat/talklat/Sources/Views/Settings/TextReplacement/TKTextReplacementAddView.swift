//
//  TKTextReplacementAddView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    
    @ObservedObject var store: TextReplacementViewStore
    
    @FocusState var focusState: Bool
    @State var phrase: String = ""
    @State var replacement: String = ""
    
    var isInputValid: Bool {
        !phrase.isEmpty && !replacement.isEmpty
    }
    
    var body: some View {
        VStack {
            SettingTRTextField(
                text: $phrase,
                focusState: _focusState,
                title: NSLocalizedString("replacement", comment: ""),
                placeholder: "아아",
                limit: 20
            )
            .onChange(of: phrase) { newValue in
                if newValue.hasPrefix(" ") {
                    phrase = String(newValue.dropFirst())
                }
            }
            
            SettingTRTextField(
                text: $replacement, title: NSLocalizedString("phrase", comment: ""),
                placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                limit: 160
            )
            .padding(.top, 24)
            .onChange(of: replacement) { newValue in
                if newValue.hasPrefix(" ") {
                    replacement = String(newValue.dropFirst())
                }
            }
            
            Spacer()
        }
        .safeAreaInset(edge: .top) {
            VStack(spacing: 10) {
                Capsule()
                    .fill(Color.GR3)
                    .frame(width: 36, height: 5)
                    .padding(.vertical, 6)
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        BDText(
                            text: NSLocalizedString("취소", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    
                    Spacer()
                    
                    BDText(
                        text: NSLocalizedString("textReplacement.add", comment: ""),
                        style: .H1_B_130
                    )
                    
                    Spacer()
                    
                    Button {
                        if isInputValid {
                            if let item: TKTextReplacement = store.makeNewTextReplacement(
                                phrase: phrase,
                                replacement: replacement
                            ) {
                                swiftDataStore.appendItem(item)
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        BDText(
                            text: NSLocalizedString("완료", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    .disabled(!isInputValid)
                    .foregroundColor(isInputValid ? .OR6 : .GR4)
                }
                .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.SheetBGWhite)
    }
}

//struct TKTextReplacementAddView_Previews: PreviewProvider {
//    @State static var isPresented = true
//    
//    static var previews: some View {
//        ZStack {
//            
//        }
//        .sheet(isPresented: .constant(true), content: {
//            TKTextReplacementAddView()
//        })
//    }
//}
