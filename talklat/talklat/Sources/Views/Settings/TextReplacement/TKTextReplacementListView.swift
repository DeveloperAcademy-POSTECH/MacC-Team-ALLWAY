//
//  TKTextReplacementListView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//  최신

import SwiftData
import SwiftUI

struct TKTextReplacementListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    
    @StateObject var store = TextReplacementViewStore()
   
    @State private var selectedList: TKTextReplacement? = nil
    
    @FocusState private var isTextFieldFocused: Bool
    
    var groupedLists: [String: [TKTextReplacement]] {
        Dictionary(grouping: swiftDataStore.textReplacements) { entry in
            if let firstChar = entry.wordDictionary.keys.first?.first {
                // 한글 첫 자음 또는 단일 자음을 추출하여 그룹화 기준으로 사용
                if let consonant = firstChar.koreanFirstConsonant {
                    return consonant
                } else {
                    // 한글 또는 영어가 아닌 경우 기본값으로 "#"
                    return firstChar.isCharacterKorean || firstChar.isCharacterEnglish
                    ? String(firstChar)
                    : "#"
                }
            } else {
                // 첫 글자가 없는 경우 기본값으로 "#"
                return "#"
            }
        }
    }
    
    var body: some View {
        VStack {
            searchBarBuilder()
                .padding(.horizontal, 16)
            
            if store(\.isSearching) {
                TKTextReplacementSearchView(
                    store: store,
                    selectedList: $selectedList,
                    lists: swiftDataStore.textReplacements
                )
            } else {
                // MARK: - 대체어 없음
                if sortedGroupKeys.isEmpty {
                    // MARK: 텅 뷰
                    VStack(spacing: 0){
                        Image(systemName: "bubble.left.and.text.bubble.right.fill")
                            .font(.system(size: 90))
                            .foregroundColor(.GR2)
                            .padding(.bottom, 30)
                        
                        BDText(text: "아직 설정한 텍스트 대치가 없어요", style: .H1_M_130)
                            .foregroundStyle(Color.GR3)
                    }
                    .frame(
                        maxHeight: .infinity,
                        alignment: .center
                    )
                }
                // MARK: - 대체어가 있음
                else if !sortedGroupKeys.isEmpty {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            ForEach(
                                sortedGroupKeys,
                                id: \.self
                            ) { groupKey in
                                // MARK: 리스트의 Header
                                Section(
                                    header:
                                        BDText(text: groupKey, style: .H2_SB_135)
                                        .id(groupKey)
                                        .foregroundColor(.GR5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 32)
                                        .padding(.top, 24)
                                ) {
                                    listSection(groupKey)
                                        .background(Color.GR1.clipShape(RoundedRectangle(cornerRadius: 15)))
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .overlay {
                            // MARK: 목차
                            if(!sortedGroupKeys.isEmpty) {
                                SectionIndexTitles(proxy: proxy)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 3)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "설정",
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: "텍스트 대치", style: .H1_B_130)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.showTextReplacementAddView()
                } label: {
                    Image(systemName: "plus")
                        .bold()
                }
                .disabled(store(\.isSearching))
            }
        }
        .sheet(isPresented: store.bindingToShowTextReplacementAddView()) {
            TKTextReplacementAddView(store: store)
        }
        .background(Color.BaseBGWhite)
    }
    
    // MARK: 리스트 정렬
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

            // 영어 알파벳 간의 정렬 처리
            if firstCharKey1?.isCharacterEnglish == true && firstCharKey2?.isCharacterEnglish == true {
                return key1 < key2 // 영어끼리는 사전식으로 정렬
            } else if firstCharKey1?.isCharacterEnglish == true {
                return false
            } else if firstCharKey2?.isCharacterEnglish == true {
                return true
            }

            // 그 외 문자들
            return key1 < key2
        }
    }

    // MARK: List 항목들 Header - list 항목
    func listSection(_ groupKey: String) -> some View {
        ForEach(
            groupedLists[groupKey] ?? [],
            id: \.self
        ) { list in
            ForEach(
                list.wordDictionary.sorted { $0.key < $1.key },
                id: \.key
            ) { key, values in
                if let firstValue = values.first {
                    NavigationLink {
                        TKTextReplacementEditView(
                            store: store
                        )
                        .onAppear {
                            store.selectTextReplacement(
                                phrase: key,
                                replacement: firstValue
                            )
                        }
                    } label: {
                        // TODO: 글자 수 말고 한 줄의 기준을 어떻게 잡을까..?
                        let displayValue = firstValue.count > 40
                        ? String(firstValue.prefix(17)) + "..."
                        : firstValue
                        
                        TextReplacementRow(
                            key: key,
                            value: displayValue
                        )
                        .cornerRadius(16)
                    }
                }
            }
        }
    }
    
    private func searchBarBuilder() -> some View {
        HStack {
            // 검색 텍스트 필드
            AWTextField(
                style: .search,
                text: store.bindingSearchText(),
                placeholder: "검색"
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if !store.viewState.searchText.isEmpty {
                    Button {
                        store.onSearchTextRemoveButtonTapped()
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.GR4)
                    }
                }
            }
            .padding(.vertical, 7)
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) { oldValue, newValue in
                if !oldValue,
                   newValue {
                    store.onSearchingText()
                }
            }
            
            if store(\.isSearching) {
                Button {
                    self.hideKeyboard()
                    store.cancelSearchAndHideKeyboard()
                    
                } label: {
                    BDText(
                        text: "취소",
                        style: .H1_B_130
                    )
                }
                .padding(.leading, 8)
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

#Preview {
    NavigationStack {
        TKTextReplacementListView()
    }
}
