//
//  TKTextReplacementEditView.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct TKTextReplacementEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @Query var textReplacements: [TKTextReplacement]
    
    @FocusState var focusState: Bool
    @Binding var isPresented: Bool
    @State private var isDialogShowing: Bool = false
    
    @State private var phrase: String
    @State private var replacement: String

    init(phrase: String, replacement: String, isPresented: Binding<Bool>) {
        _phrase = State(initialValue: phrase)
        _replacement = State(initialValue: replacement)
        _isPresented = isPresented
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                SettingTRTextField(title: "단축 문구", placeholder: "아아", limit: 20, text: $phrase, focusState: _focusState)
                SettingTRTextField(title: "변환 문구", placeholder: "아이스 아메리카노 한 잔 주시겠어요?", limit: 160, text: $replacement)
                    .padding(.top, 36)
                
                Spacer()

                Button(action: {
                    self.isDialogShowing = true
                }) {
                    Text("텍스트 대체 삭제")
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
            .navigationTitle("편집")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17))
                    Text("목록")
                        .font(.headline)
                }
            })
            .navigationBarItems(trailing: Button("저장") {
                if let existingItem = fetchTKTextReplacement(forPhrase: phrase) {
                    existingItem.wordDictionary = [phrase: replacement]
                } else {
                    let newItem = TKTextReplacement(wordDictionary: [phrase: replacement])
                    context.insert(newItem)
                }
                isPresented = false
            })
        }
        .background(
            Group {
                if isDialogShowing {
                    Color.black.opacity(0.5).ignoresSafeArea() // 반투명 배경
                }
            }
        )
        .overlay(
            Group {
                if isDialogShowing {
                    CustomDialog(
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
        return fetchedItems.first
    }
}

struct CustomDialog: View {
    @Binding internal var isDialogShowing: Bool
    
    var onDelete: () -> Void // 새로운 클로저 추가
    
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
                        onDelete() // 삭제 메소드 호출
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

// TKTextReplacementEditView_Previews 구조체
struct TKTextReplacementEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented = true
        TKTextReplacementEditView(phrase: "아아", replacement: "아이스 아메리카노 한 잔 주시겠어요?", isPresented: $isPresented)
    }
}
