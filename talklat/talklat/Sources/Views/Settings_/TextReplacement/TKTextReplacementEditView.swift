//
//  TKTextReplacementEditView.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store: TextReplacementViewStore
    
    @Query var textReplacements: [TKTextReplacement]
    
    @FocusState var focusState: Bool
    
    let dataStore = TKSwiftDataStore()
    

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                VStack {
                    SettingTRTextField(
                        text: store.bindingPhraseTextField(),
                        focusState: _focusState,
                        title: "단축어",
                        placeholder: "아아",
                        limit: 20
                    )
                    .focused($focusState)
                    
                    SettingTRTextField(
                        text: store.bindingReplacementTextField(),
                        title: "변환 문구",
                        placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                        limit: 160
                    )
                    .focused($focusState)
                    .padding(.top, 36)
                }
                
                Spacer()
                
                if !focusState {
                    Button {
                        store.onShowDialogButtonTapped()
                    } label: {
                        Text("텍스트 대치 삭제")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color.BaseBGWhite)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.RED)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
        }
        .padding()
        .padding(.top, 8)
        .onTapGesture {
            self.hideKeyboard()
        }
        .navigationTitle("편집")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .disabled(store(\.isDialogShowing))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("저장") {
                    updateTextReplacement()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(store.isSaveButtonDisabled)
                .foregroundColor(store.isSaveButtonDisabled ? Color.GR4 : Color.OR6)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        Text("목록")
                            .font(.system(size: 17))
                    }
                    .tint(Color.OR5)
                }
            }
        }
        .overlay {
            ZStack {
                if store(\.isDialogShowing) {
                    Color.GR9.opacity(0.5).ignoresSafeArea(.all)
                    TKAlert(
                        style: .removeTextReplacement,
                        isPresented: store.bindingReplacementRemoveAlert()
                    ) {
                        deleteTKTextReplacement()
                        
                    } actionButtonLabel: {
                        Text("네, 삭제할래요")
                    }
                }
            }
        }
    }
    
    private func updateTextReplacement() {
        let selectedPhrase = store(\.selectedPhrase)
        let selectedReplacement = store(\.selectedReplacement)
        
        // 기존에 TKTextReplacement가 존재하는지 확인
        let existingItem = fetchTKTextReplacement()

        // 새로운 TKTextReplacement를 생성하고 저장
        dataStore.createTextReplacement(phrase: selectedPhrase, replacement: selectedReplacement)

        // 기존에 존재하는 데이터가 있으면, 새 데이터를 저장한 후에 삭제
        if let existing = existingItem {
            context.delete(existing)
        }
    }

    private func fetchTKTextReplacement() -> TKTextReplacement? {
        
        let selectedPhrase = store(\.selectedPhrase)
        let selectedReplacement = store(\.selectedReplacement)
        
        // selectedPhrase가 새로운 경우
        if !textReplacements.contains(where: { $0.wordDictionary.keys.contains(selectedPhrase) }) {
            // 새로운 단축어, 변환 문구 모두 새로운 경우
            if textReplacements.contains(where: { $0.wordDictionary.values.contains { $0.contains(selectedReplacement) } }) {
                return textReplacements.first(where: { $0.wordDictionary.values.contains { $0.contains(selectedReplacement) } })
            }

            // 새로운 단축어, 기존 변환 문구 사용 경우
            else if textReplacements.contains(where: { replacement in
                replacement.wordDictionary.values.contains(where: { phrases in
                    phrases.contains(selectedReplacement)
                })
            }) {
                return textReplacements.first(where: { replacement in
                    replacement.wordDictionary.values.contains(where: { phrases in
                        phrases.contains(selectedReplacement)
                    })
                })
            }

        }
        // 기존 단축어, 새로운 변환 문구 사용 경우
        else {
            return textReplacements.first(where: { $0.wordDictionary.keys.contains(selectedPhrase) })
        }
        
        let fetchedItems = textReplacements.filter { $0.wordDictionary.keys.contains(selectedPhrase) }
        
        return fetchedItems.last
    }
    
    private func deleteTKTextReplacement() {
        if let existingItem = fetchTKTextReplacement() {
            context.delete(existingItem)
        }
            
        presentationMode.wrappedValue.dismiss()
    }
}

struct TextReplacementCustomDialog: View {
    @Binding internal var isDialogShowing: Bool
    
    var onDelete: () -> Void
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.RED)
                    .font(.system(size: 20))
                
                Text("텍스트 대치 삭제")
                    .foregroundColor(.GR9)
                    .font(.system(size: 17, weight: .bold))
                
                Text("현재 텍스트 대치가 삭제됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.GR6)
                    .font(.system(size: 15, weight: .medium))
                
                HStack {
                    Button {
                        isDialogShowing = false
                        
                    } label: {
                        Text("아니요, 취소할래요")
                            .foregroundColor(.GR6)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.GR2)
                            .cornerRadius(16)
                    }
                    
                    Button {
                        onDelete()
                        isDialogShowing = false
                        
                    } label: {
                        Text("네, 삭제할래요")
                            .foregroundColor(.BaseBGWhite)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.RED)
                            .cornerRadius(16)
                    }
                }
            }
        }
        .background(Color.BaseBGWhite)
        .cornerRadius(22)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
    }
}
