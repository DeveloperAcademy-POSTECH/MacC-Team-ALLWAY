//
//  TKTextReplacementEditView.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementEditView: View, FirebaseAnalyzable {
    @Environment(\.presentationMode) var presentationMode
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    
    @ObservedObject var store: TextReplacementViewStore
    
    @FocusState var shortTextFieldFocusState: Bool
    @FocusState var longTextFieldFocusState: Bool
    
    
    let firebaseStore: any TKFirebaseStore = SettingsTextReplacementEditFirebaseStore()
    
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                SettingTRTextField(
                    text: store.bindingPhraseTextField(),
                    focusState: _shortTextFieldFocusState,
                    allowSpace: false, title: "단축어",
                    placeholder: "아아",
                    limit: 20
                )
                .focused($shortTextFieldFocusState)
                .onChange(of: shortTextFieldFocusState) {
                    if shortTextFieldFocusState == true {
                        firebaseStore.userDidAction(.tapped(.shortenTextField))
                    }
                }
                
                SettingTRTextField(
                    text: store.bindingReplacementTextField(),
                    focusState: _longTextFieldFocusState,
                    title: "변환 문구",
                    placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                    limit: 160
                )
                .padding(.top, 36)
                .focused($longTextFieldFocusState)
                .onChange(of: longTextFieldFocusState) {
                    if longTextFieldFocusState == true {
                        firebaseStore.userDidAction(.tapped(.fullTextField))
                    }
                }
            }
            
            Spacer()
            
            if !shortTextFieldFocusState {
                Button {
                    firebaseStore.userDidAction(.tapped(.delete))
                    store.onShowDialogButtonTapped()
                } label: {
                    BDText(text: "텍스트 대치 삭제", style: .H1_B_130)
                        .foregroundColor(Color.white)
                        .cornerRadius(22)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.RED)
                .cornerRadius(22)
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
        .onAppear {
            firebaseStore.userDidAction(
                .viewed,
                .textReplacementType(
                    store.bindingPhraseTextField().wrappedValue,
                    store.bindingReplacementTextField().wrappedValue
                )
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "목록",
                            style: .H1_B_130
                        )
                    }
                }
                .tint(Color.OR6)
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: "편집",
                    style: .H1_B_130
                )
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    firebaseStore.userDidAction(
                        .tapped(.save),
                        .textReplacementType(
                            store.bindingPhraseTextField().wrappedValue,
                            store.bindingPhraseTextField().wrappedValue
                        )
                    )
                    updateTextReplacement()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    BDText(
                        text: "저장",
                        style: .H1_B_130
                    )
                }
                .disabled(store.isSaveButtonDisabled)
                .foregroundColor(
                    store.isSaveButtonDisabled
                    ? Color.GR4
                    : Color.OR6
                )
            }
        }
        .showTKAlert(
            isPresented: store.bindingShowTKAlert(),
            style: .removeTextReplacement(title: "텍스트 대치 삭제"),
            onDismiss: {
                firebaseStore.userDidAction(.tapped(.alertBack(firebaseStore.viewId)))
                store.onDismissRemoveAlert()
            },
            confirmButtonAction: {
                firebaseStore.userDidAction(.tapped(.alertDelete(firebaseStore.viewId)))
                swiftDataStore.removeItem(identifyTextReplacement())
                presentationMode.wrappedValue.dismiss()
                store.onDismissRemoveAlert()
            },
            confirmButtonLabel: {
                BDText(text: "네, 삭제할래요", style: .H2_SB_135)
            }
        )
    }
    
    private func identifyTextReplacement() -> TKTextReplacement {
        // 선택된 항목과 일치하는 TKTextReplacement를 담아줄 변수
        var identicalTextReplacement: TKTextReplacement = TKTextReplacement(
            wordDictionary: [:]
        )
        
        // selectedPhrase, selectedReplacement를 사용하기 용이한 TKTextReplacement 형태로 감싸기
        if let selectedItem: TKTextReplacement = store.makeNewTextReplacement(
            phrase: store(\.selectedPhrase),
            replacement: store(\.selectedReplacement)
        ) {
            // SwiftData 저장소에서 선택된 항목과 일치하는 인스턴스 탐색
            swiftDataStore.textReplacements.forEach { textReplacement in
                textReplacement.wordDictionary.forEach { word in
                    if selectedItem.wordDictionary.keys.contains(word.key) {
                        identicalTextReplacement = textReplacement
                    }
                }
            }
        }
        
        return identicalTextReplacement
    }
    
    
    private func updateTextReplacement() {
        let selectedPhrase = store(\.selectedPhrase)
        let selectedReplacement = store(\.selectedReplacement)
        
        // 기존에 TKTextReplacement가 존재하는지 확인
        let existingItem = fetchTKTextReplacement()
        
        // 새로운 TKTextReplacement를 생성하고 저장
        if let item: TKTextReplacement = store.makeNewTextReplacement(
            phrase: selectedPhrase,
            replacement: selectedReplacement
        ) {
            swiftDataStore.appendItem(item)
        }
        
        // 기존에 존재하는 데이터가 있으면, 새 데이터를 저장한 후에 삭제
        if let existing = existingItem {
            swiftDataStore.removeItem(existing)
        }
    }
    
    private func fetchTKTextReplacement() -> TKTextReplacement? {
        
        let selectedPhrase = store(\.selectedPhrase)
        let selectedReplacement = store(\.selectedReplacement)
        
        // selectedPhrase가 새로운 경우
        if !swiftDataStore.textReplacements.contains(where: {
            $0.wordDictionary.keys.contains(selectedPhrase)
        }) {
            // 새로운 단축어, 변환 문구 모두 새로운 경우
            if swiftDataStore.textReplacements.contains(where: {
                $0.wordDictionary.values.contains { $0.contains(selectedReplacement) }
            }) {
                return swiftDataStore.textReplacements.first(where: {
                    $0.wordDictionary.values.contains { $0.contains(selectedReplacement) }
                })
            }
            
            // 새로운 단축어, 기존 변환 문구 사용 경우
            else if swiftDataStore.textReplacements.contains(where: { replacement in
                replacement.wordDictionary.values.contains(where: { phrases in
                    phrases.contains(selectedReplacement)
                })
            }) {
                return swiftDataStore.textReplacements.first(where: { replacement in
                    replacement.wordDictionary.values.contains(where: { phrases in
                        phrases.contains(selectedReplacement)
                    })
                })
            }
            
        }
        // 기존 단축어, 새로운 변환 문구 사용 경우
        else {
            return swiftDataStore.textReplacements.first(where: {
                $0.wordDictionary.keys.contains(selectedPhrase)
            })
        }
        
        let fetchedItems = swiftDataStore.textReplacements.filter {
            $0.wordDictionary.keys.contains(selectedPhrase)
        }
        
        return fetchedItems.last
    }
    
//    private func deleteTKTextReplacement() {
//        if let existingItem = fetchTKTextReplacement() {
//            swiftDataStore.removeItem(existingItem)
//        }
//        
//        presentationMode.wrappedValue.dismiss()
//    }
}
