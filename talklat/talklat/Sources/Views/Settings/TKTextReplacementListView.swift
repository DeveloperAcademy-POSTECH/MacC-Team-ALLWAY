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
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if sortedGroupKeys.isEmpty {
                            Spacer()
                            Image(systemName: "ellipsis.message")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text("아직 설정한 텍스트 대치가 없어요")
                            Spacer()
                        } else {
                            ForEach(sortedGroupKeys, id: \.self) { groupKey in
                                // Header
                                Section(header: Text(groupKey)
                                    .id(groupKey)
                                    .font(.subheadline)
                                    .foregroundColor(.gray500)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 32)
                                    .padding(.top, 24)
                                    .lineSpacing(15 * 1.35 - 15)
                                )
                                {
                                    listSection(groupKey)
                                }
                                
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay {
                    if(!sortedGroupKeys.isEmpty) {
                        SectionIndexTitles(proxy: proxy)
                            .frame(maxWidth: .infinity, alignment: .trailing)
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
    
    var sortedGroupKeys: [String] {
        groupedLists.keys.sorted()
    }
    
    func listSection(_ groupKey: String) -> some View {
        ForEach(groupedLists[groupKey] ?? [], id: \.self) { list in
            ForEach(list.wordDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                TextReplacementRow(key: key, value: value, list: list, selectedList: $selectedList)
                    .padding(.horizontal, 16)
//                    .padding(.bottom, 24)
                    .cornerRadius(20)
            }
        }
    }
}
