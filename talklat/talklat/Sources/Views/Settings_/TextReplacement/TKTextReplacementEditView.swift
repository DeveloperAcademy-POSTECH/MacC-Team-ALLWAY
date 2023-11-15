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
        VStack(spacing: 10) {
            SettingTRTextField(
                text: store.bindingPhraseTextField(),
                focusState: _focusState,
                title: "단축어",
                placeholder: "아아",
                limit: 20
            )
            
            SettingTRTextField(
                text: store.bindingReplacementTextField(),
                title: "변환 문구",
                placeholder: "아이스 아메리카노 한 잔 주시겠어요?",
                limit: 160
            )
                .padding(.top, 36)
            
            Spacer()
            
            Button {
                store.onShowDialogButtonTapped()
                
            } label: {
                Text("텍스트 대치 삭제")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .padding()
        .padding(.top, 8)
        .navigationTitle("편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("저장") {
                    updateTextReplacement()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .background {
            if store(\.isDialogShowing) {
                Color.black.opacity(0.5).ignoresSafeArea()
            }
        }
        .overlay {
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
    
    private func updateTextReplacement() {
        if let existingItem = fetchTKTextReplacement(forPhrase: store(\.selectedPhrase)) {
            dataStore.updateTextReplacement(
                oldTextReplacement: existingItem,
                newPhrase: store(\.selectedPhrase),
                newReplacement: store(\.selectedReplacement)
            )
        }
    }
    
    private func fetchTKTextReplacement(forPhrase phrase: String) -> TKTextReplacement? {
        let fetchedItems = textReplacements.filter { $0.wordDictionary.keys.contains(phrase) }
        return fetchedItems.last
    }
    
    private func deleteTKTextReplacement() {
        if let existingItem = fetchTKTextReplacement(forPhrase: store(\.selectedPhrase)) {
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
                    .foregroundColor(.red)
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
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.red)
                            .cornerRadius(16)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(22)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
    }
}
