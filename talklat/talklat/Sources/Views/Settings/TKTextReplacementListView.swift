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
    
    @ObservedObject var settingStore = SettingViewStore(settingState: .init())
    
    var groupedLists: [String: [TKTextReplacement]] {
        Dictionary(grouping: lists) { entry in
            entry.wordDictionary.keys.first?.headerKey ?? "#"
        }
    }
    
    var body: some View {
        NavigationView {
            // TODO: SearchBar
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
                        settingStore.showTextReplacementAddView()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: settingStore.bindingToShowTextReplacementAddView()) {
                TKTextReplacementAddView()
            }
            .fullScreenCover(isPresented: settingStore.bindingToShowTextReplacementEditView(), content: {
                if let selectedPhrase = settingStore.viewState.selectedPhrase,
                   let selectedReplacement = settingStore.viewState.selectedReplacement {
                    TKTextReplacementEditView(
                        phrase: selectedPhrase,
                        replacement: selectedReplacement,
                        isPresented: settingStore.bindingToShowTextReplacementEditView()
                    )
                }
            })
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    var sortedGroupKeys: [String] {
        return groupedLists.keys.sorted { key1, key2 in
            let firstCharKey1 = key1.first
            let firstCharKey2 = key2.first

            // 한글을 가장 앞에 배치
            if firstCharKey1?.isKorean == true && firstCharKey2?.isKorean == false {
                return false  // key1이 한글일 때 앞에 오도록
            } else if firstCharKey1?.isKorean == false && firstCharKey2?.isKorean == true {
                return true  // key2가 한글일 때 뒤에 오도록
            }

            // 영어를 그 다음으로 배치
            if firstCharKey1?.isEnglish == true && firstCharKey2?.isEnglish == false {
                return false  // key1이 영어일 때 앞에 오도록
            } else if firstCharKey1?.isEnglish == false && firstCharKey2?.isEnglish == true {
                return true  // key2가 영어일 때 뒤에 오도록
            }

            // 그 외 문자들은 자연스러운 문자열 순서에 따라 배치
            return key1 < key2
        }
    }

    func listSection(_ groupKey: String) -> some View {
        ForEach(groupedLists[groupKey] ?? [], id: \.self) { list in
            ForEach(list.wordDictionary.sorted { $0.key < $1.key }, id: \.key) { key, values in
                // 첫 번째 값만 사용
                if let firstValue = values.first {
                    TextReplacementRow(key: key, value: firstValue, list: list, selectedList: $selectedList)
                        .padding(.horizontal, 16)
                        .cornerRadius(16)
                        .simultaneousGesture(TapGesture().onEnded {
                            print("Tap gesture on Button\n")
                            settingStore.selectTextReplacement(phrase: key, replacement: firstValue)
                        })
                }
            }
        }
    }

}

extension String {
    var isKorean: Bool {
        self.first?.isKorean ?? false
    }
    
    var isEnglish: Bool {
        self.first?.isEnglish ?? false
    }
}

extension Character {
    var isKorean: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.value >= 0xAC00 && scalar.value <= 0xD7A3
    }
    
    var isEnglish: Bool {
        return isLetter && isASCII
    }
}
