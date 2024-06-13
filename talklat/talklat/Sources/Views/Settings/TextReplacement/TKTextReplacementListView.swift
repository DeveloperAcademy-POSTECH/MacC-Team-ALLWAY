//
//  TKTextReplacementListView.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//  최신

import SwiftData
import SwiftUI

struct TKTextReplacementListView: View, FirebaseAnalyzable {
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
    
    let firebaseStore: any TKFirebaseStore = SettingsTextReplacementFirebaseStore()
    
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
                        
                        BDText(
                            text: NSLocalizedString("settings.textReplacement.list.noItems", comment: "No items message"),
                            style: .H1_SB_130
                        )
                        .foregroundStyle(Color.GR3)
                        .multilineTextAlignment(.center)
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
                                        .background(Color.ExceptionWhite17.clipShape(RoundedRectangle(cornerRadius: 15)))
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
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    firebaseStore.userDidAction(.tapped(.back))
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: NSLocalizedString("설정", comment: ""),
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: NSLocalizedString("textReplacement.title", comment: ""), style: .H1_B_130)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(
                        .spring(
                            dampingFraction: 0.7,
                            blendDuration: 0.4
                        )
                    ) {
                        firebaseStore.userDidAction(.tapped(.add))
                        store.showTextReplacementAddView()
                    }
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
        .background(Color.ExceptionWhiteW8)
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
                    
                    let processedValue = firstValue
                        .split(separator: "\n")
                        .map { String($0).trimmingCharacters(in: .whitespaces) }
                        .joined(separator: "\n")
                    
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
//                        let displayValue = firstValue.count > 40
//                        ? String(firstValue.prefix(17)) + "..."
//                        : firstValue
                        
                        TextReplacementRow(
                            key: key,
                            value: processedValue,
                            lineLimit: 2
                        )
                        .cornerRadius(16)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                print("HI hello")
                                firebaseStore.userDidAction(.tapped(.item))
                            }
                    )
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
                placeholder: NSLocalizedString("settings.textReplacement.search.placeholder", comment: "Search")
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if !store.viewState.searchText.isEmpty {
                    Button {
                        firebaseStore.userDidAction(.tapped(.eraseAll))
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
                withAnimation(
                    .spring(
                        dampingFraction: 0.8,
                        blendDuration: 0.4
                    )
                ) {
                    if !oldValue,
                       newValue {
                        firebaseStore.userDidAction(.tapped(.field))
                        store.onSearchingText()
                    }
                }
            }
            
            if store(\.isSearching) {
                Button {
                    withAnimation(
                        .spring(
                            dampingFraction: 0.8,
                            blendDuration: 0.9
                        )
                    ) {
                        firebaseStore.userDidAction(.tapped(.cancel))
                        self.hideKeyboard()
                        store.cancelSearchAndHideKeyboard()
                    }
                } label: {
                    BDText(
                        text: NSLocalizedString("취소", comment: ""),
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
