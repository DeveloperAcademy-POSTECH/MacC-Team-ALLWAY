//
//  TKTextReplacementAddView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementAddView: View, FirebaseAnalyzable {
    @Environment(\.presentationMode) var presentationMode
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    
    @ObservedObject var store: TextReplacementViewStore
    
    @FocusState var shortTextFieldFocusState: Bool
    @FocusState var longTextFieldFocusState: Bool
    @State var phrase: String = ""
    @State var replacement: String = ""
    
    var isInputValid: Bool {
        !phrase.isEmpty && !replacement.isEmpty
    }
    
    let firebaseStore: any TKFirebaseStore = SettingsTextReplacementAddFirebaseStore()
    
    var body: some View {
        VStack {
            SettingTRTextField(
                text: $phrase,
                focusState: _shortTextFieldFocusState,
                title: "단축어",
                placeholder: "아아",
                limit: 20
            )
            .onChange(of: shortTextFieldFocusState) {
                if shortTextFieldFocusState == true {
                    firebaseStore.userDidAction(.tapped(.shortenTextField))
                }
            }
            .onChange(of: phrase) { newValue in
                if newValue.hasPrefix(" ") {
                    phrase = String(newValue.dropFirst())
                }
            }
            
            SettingTRTextField(
                text: $replacement,
                focusState: _longTextFieldFocusState,
                title: "변환 문구",
                placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                limit: 160
            )
            .padding(.top, 24)
            .onChange(of: longTextFieldFocusState) {
                if longTextFieldFocusState == true {
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "fullTextField",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.fullTextField))
                }
            }
            .onChange(of: replacement) { newValue in
                if newValue.hasPrefix(" ") {
                    replacement = String(newValue.dropFirst())
                }
            }
            
            Spacer()
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .safeAreaInset(edge: .top) {
            VStack(spacing: 10) {
                Capsule()
                    .fill(Color.GR3)
                    .frame(width: 36, height: 5)
                    .padding(.vertical, 6)
                
                HStack {
                    Button {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "cancel",
//                            nil
//                        )
                        firebaseStore.userDidAction(.tapped(.cancel))
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        BDText(
                            text: "취소",
                            style: .H1_B_130
                        )
                    }
                    
                    Spacer()
                    
                    BDText(
                        text: "텍스트 대치 추가",
                        style: .H1_B_130
                    )
                    
                    Spacer()
                    
                    Button {
                        if isInputValid {
//                            firebaseStore.userDidAction(
//                                .tapped,
//                                "complete",
//                                nil
//                            )
                            firebaseStore.userDidAction(.tapped(.complete))
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
                            text: "완료",
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
