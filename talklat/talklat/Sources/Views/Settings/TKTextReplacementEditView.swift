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
    
    @Query var textReplacements: [TKTextReplacement]
    
    @FocusState var focusState: Bool
    @Binding var isPresented: Bool
    @State private var isDialogShowing: Bool = false
    @State private var phrase: String
    @State private var replacement: String
    
    var textReplacementManager: TKTextReplacementManager
    
    init(phrase: String, replacement: String, isPresented: Binding<Bool>, textReplacementManager: TKTextReplacementManager) {
        _phrase = State(initialValue: phrase)
        _replacement = State(initialValue: replacement)
        _isPresented = isPresented
        self.textReplacementManager = textReplacementManager
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                SettingTRTextField(text: $phrase, focusState: _focusState, title: "단축 문구", placeholder: "아아", limit: 20)
                SettingTRTextField(text: $replacement, title: "변환 문구", placeholder: "아이스 아메리카노 한 잔 주시겠어요?", limit: 160)
                    .padding(.top, 36)
                
                Spacer()
                
                Button(action: {
                    self.isDialogShowing = true
                }) {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17))
                            Text("목록")
                                .font(.headline)
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("저장") {
                        try? context.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .background(
            Group {
                if isDialogShowing {
                    Color.black.opacity(0.5).ignoresSafeArea()
                }
            }
        )
        .overlay(
            Group {
                if isDialogShowing {
                    TextReplacementCustomDialog(
                        isDialogShowing: $isDialogShowing,
                        onDelete: deleteTKTextReplacement
                    )
                }
            }
        )
    }
    
    private func deleteTKTextReplacement() {
        if let existingItem = fetchTKTextReplacement(forPhrase: phrase) {
            context.delete(existingItem)
        }
            
        isPresented = false
    }
    
    private func fetchTKTextReplacement(forPhrase phrase: String) -> TKTextReplacement? {
        let fetchedItems = textReplacements.filter { $0.wordDictionary.keys.contains(phrase) }
        return fetchedItems.last
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
                    .foregroundColor(.gray900)
                    .font(.system(size: 17, weight: .bold))
                
                Text("현재 텍스트 대치가 삭제됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray600)
                    .font(.system(size: 15, weight: .medium))
                
                HStack {
                    Button {
                        isDialogShowing = false
                    } label: {
                        Text("아니요, 취소할래요")
                            .foregroundColor(.gray600)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.gray200)
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
