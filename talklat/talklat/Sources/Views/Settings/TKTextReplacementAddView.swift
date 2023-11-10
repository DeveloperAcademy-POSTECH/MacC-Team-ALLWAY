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
    
    @Binding var isPresented: Bool
    
    @State private var phrase: String = ""
    @State private var replacement: String = ""
    
    let manager = TKTextReplacementManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("문구")
                    Spacer()
                }

                TextField("줄임말을 입력해주세요 ex)아아", text: $phrase)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(22)
                
                HStack {
                    Text("변환 문구")
                    Spacer()
                }
                
                TextField("대치할 텍스트를 입력해주세요 ex)아이스 아메리카노", text: $replacement)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(22)
                
                Spacer()
            }
            .padding()
            .navigationTitle("텍스트 대치 추가")
            .navigationBarItems(leading: Button("취소") {
                isPresented = false
            })
            .navigationBarItems(trailing: Button("완료") {
                // TODO: Save New Dictionary of TextReplacement
                manager.addTextReplacement(phrase: phrase, replacement: replacement)
                isPresented = false
                
//                let newItem = TKTextReplacement(wordDictionary: [phrase: replacement])
//                context.insert(newItem)
//                isPresented = false
            })
        }
    }
}
