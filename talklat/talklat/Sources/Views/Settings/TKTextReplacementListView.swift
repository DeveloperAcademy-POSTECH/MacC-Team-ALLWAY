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
    @ObservedObject var settingStore = SettingViewStore(settingState: .init())
    
    @Query private var lists: [TKTextReplacement]
    
    @State private var selectedList: TKTextReplacement? = nil
    
    var textReplacementManager = TKTextReplacementManager()
    
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
                            // MARK: 텅 뷰
                            Spacer()
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 30))
                                .foregroundColor(.GR3)
                                .padding(.bottom, 30)
                            Text("아직 설정한 텍스트 대치가 없어요")
                                .foregroundStyle(Color.GR3)
                                .font(.system(size: 17, weight: .medium))
                            Spacer()
                        } else {
                            ForEach(sortedGroupKeys, id: \.self) { groupKey in
                                // MARK: 리스트의 Header
                                Section(header: Text(groupKey)
                                    .id(groupKey)
                                    .font(.subheadline)
                                    .foregroundColor(.GR5)
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
                    // MARK: 목차
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
                        isPresented: settingStore.bindingToShowTextReplacementEditView(),
                        textReplacementManager: textReplacementManager
                    )
                }
            })
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    // MARK: 리스트 정렬
    // TODO: #(그 외 문자들)이 젤 먼저 나온다ㅠㅠ수정..
    var sortedGroupKeys: [String] {
        return groupedLists.keys.sorted { key1, key2 in
            let firstCharKey1 = key1.first
            let firstCharKey2 = key2.first

            // 한글을 가장 앞에 배치
            if firstCharKey1?.isCharacterKorean == true && firstCharKey2?.isCharacterKorean == false {
                return false
            } else if firstCharKey1?.isCharacterKorean == false && firstCharKey2?.isCharacterKorean == true {
                return true
            }

            // 영어를 그 다음으로 배치
            if firstCharKey1?.isCharacterEnglish == true && firstCharKey2?.isCharacterEnglish == false {
                return false
            } else if firstCharKey1?.isCharacterEnglish == false && firstCharKey2?.isCharacterEnglish == true {
                return true
            }

            // 그 외 문자들
            return key1 < key2
        }
    }

    // MARK: List 항목들 Header - list 항목
    func listSection(_ groupKey: String) -> some View {
        ForEach(groupedLists[groupKey] ?? [], id: \.self) { list in
            ForEach(list.wordDictionary.sorted { $0.key < $1.key }, id: \.key) { key, values in
                if let firstValue = values.first {
                    // TODO: 글자 수 말고 한 줄의 기준을 어떻게 잡을까..?
                    let displayValue = firstValue.count > 40 ? String(firstValue.prefix(17)) + "..." : firstValue
                    TextReplacementRow(selectedList: $selectedList, key: key, value: displayValue, list: list)
                        .padding(.horizontal, 16)
                        .cornerRadius(16)
                        .simultaneousGesture(TapGesture().onEnded {
                            settingStore.selectTextReplacement(phrase: key, replacement: firstValue)
                        })
                }
            }
        }
    }
}

// MARK: 리스트 정렬 용
extension String {
    var isKoreanSection: Bool {
        self.first?.isCharacterKorean ?? false
    }
    
    var isEnglishSection: Bool {
        self.first?.isCharacterEnglish ?? false
    }
}

extension Character {
    var isCharacterKorean: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.value >= 0xAC00 && scalar.value <= 0xD7A3
    }
    
    var isCharacterEnglish: Bool {
        return isLetter && isASCII
    }
}
