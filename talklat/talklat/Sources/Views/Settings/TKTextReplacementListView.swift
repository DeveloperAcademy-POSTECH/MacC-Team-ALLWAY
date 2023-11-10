//
//  TKTextReplacementListView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftData
import SwiftUI

struct TKTextReplacementListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.modelContext) private var context
    @Query private var lists: [TKTextReplacement]
    
    @State private var selectedList: TKTextReplacement? = nil
    @State private var showingAddView = false
    
    var groupedLists: [String: [TKTextReplacement]] {
        Dictionary(grouping: lists) { $0.wordDictionary.keys.first?.headerKey ?? "#" }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedLists.keys.sorted(), id: \.self) { groupKey in
                    Section(header: Text(groupKey).frame(maxWidth: .infinity, alignment: .leading).background(Color.white)) {
                        ForEach(groupedLists[groupKey] ?? [], id: \.self) { list in
                            ForEach(list.wordDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                TextReplacementRow(key: key, value: value, list: list, selectedList: $selectedList)
                            }
                        }
                    }
                    
                }
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17))
                    Text("설정")
                        .font(.headline)
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddTextReplacementView(isPresented: self.$showingAddView)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TextReplacementRow: View {
    var key: String
    var value: String
    var list: TKTextReplacement
    @Binding var selectedList: TKTextReplacement?

    var body: some View {
        Button(action: {
            selectedList = list
        }) {
            VStack(spacing: 0) {
                Text(key)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(17 * 1.3 - 17)
//                    .padding(.vertical, (17 * 1.3 - 17) / 2)
                    .padding(.vertical, 10)
                    .padding(.leading, 16)
                
                Divider()
                    .padding(.leading, 16)
                
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(15 * 1.35 - 15)
//                    .padding(.vertical, (15 * 1.35 - 15) / 2)
                    .padding(.vertical, 10)
                    .padding(.leading, 16)
                    
            }
            .cornerRadius(20)
        }
        .background(Color.gray100)
    }
}

struct TextReplacementRow_Previews: PreviewProvider {
    @State static var selectedList: TKTextReplacement?

    static var previews: some View {
        TextReplacementRow(key: "Sample Key", value: "Sample Value", list: TKTextReplacement(wordDictionary: ["아이스":"아메리카노"]), selectedList: $selectedList)
    }
}
