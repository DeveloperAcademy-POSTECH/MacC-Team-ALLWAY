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
                            .foregroundColor(Color.white)
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
//        .onTapGesture {
//            self.hideKeyboard()
//        }
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
        if let existingItem = fetchTKTextReplacement() {
            dataStore.updateTextReplacement(
                oldTextReplacement: existingItem,
                newPhrase: store(\.selectedPhrase),
                newReplacement: store(\.selectedReplacement)
            )
        }
    }
    
    private func fetchTKTextReplacement() -> TKTextReplacement? {
    
        
        if let currentTKReplacement = textReplacements.filter { $0.wordDictionary.keys.contains(store(\.selectedPhrase)) }.last {
            // 단축어는 바꾸지 않고(==오리지널), 변환 문구(==selected)만 바꾼 케이스
            // replacement의 경우, originalReplacement != selectedReplacement
            
        }
        
        // 단축어만 바꾸고, 변환문구는 안 바꾼 케이스
        
        let selectedPhrase = store(\.selectedPhrase)
        let selectedReplacement = store(\.selectedReplacement)
        
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
