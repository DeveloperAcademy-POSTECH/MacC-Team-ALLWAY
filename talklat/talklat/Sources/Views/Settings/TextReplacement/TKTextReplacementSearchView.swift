//
//  TKTextReplacementSearchView.swift
//  talklat
//
//  Created by 신정연 on 11/15/23.
//

import SwiftData
import SwiftUI

// MARK: 텍스트 대치 검색 결과 화면
struct TKTextReplacementSearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    @ObservedObject var store: TextReplacementViewStore
    @Binding var selectedList: TKTextReplacement?
    
    var lists: [TKTextReplacement]

    var filteredLists: [TKTextReplacement] {
        if store(\.searchText).isEmpty {
            return []
        } else {
            return lists.filter { list in
                let searchTextLowercased = store(\.searchText).lowercased()
                let matchInKeys = list.wordDictionary.keys.contains { key in
                    key.lowercased().contains(searchTextLowercased)
                }
                let matchInValues = list.wordDictionary.values.flatMap { $0 }.contains { value in
                    value.lowercased().contains(searchTextLowercased)
                }
                return matchInKeys || matchInValues
            }
        }
    }

    var body: some View {
        if filteredLists.isEmpty {
            emptySearchResultView
        } else {
            ScrollView {
                searchResultList
            }
        }
    }
    
    private var emptySearchResultView: some View {
        VStack {
            Spacer()
            Image(colorScheme == .light ? "search.result.none.light" : "search.result.none.dark")
                .padding(.bottom, 40)
            BDText(
                text: NSLocalizedString("noSearchResult", comment: ""),
                style: .H1_B_130
            )
                .foregroundColor(Color.GR3)
            Spacer()
        }
    }
    
    private var searchResultList: some View {
        ForEach(
            filteredLists,
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
                            selectedList = list
                            
                            store.selectTextReplacement(
                                phrase: key,
                                replacement: firstValue
                            )
                        }
                        
                    } label: {
                        ReplacementSearchResultCell(
                            store: store,
                            key: key,
                            firstReplacement: firstValue
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    TKTextReplacementListView()
//    ReplacementSearchResultCell(
//        store: TextReplacementViewStore(viewState: .init()),
//        key: "gd",
//        firstReplacement: "gd"
//    )
}

extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var start = startIndex
        while let range = range(of: searchString, options: .caseInsensitive, range: start..<endIndex) {
            ranges.append(range)
            start = range.upperBound
        }
        return ranges
    }
}

struct ReplacementSearchResultCell: View {
    @ObservedObject var store: TextReplacementViewStore
    let key: String
    let firstReplacement: String
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            highlightSearchText(in: key)
                .font(.system(size: 17, weight: .bold))
                .lineSpacing(17 * 1.3 - 17)
                .foregroundStyle(Color.GR7)
            
            Divider()
            
            highlightSearchText(
                in: firstReplacement.count > 30
                ? String(firstReplacement.prefix(29)) + "..."
                : firstReplacement
            )
            .font(.system(size: 15, weight: .medium))
            .lineSpacing(15 * 1.35 - 15)
            .foregroundStyle(Color.GR5)
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.GR1)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func highlightSearchText(in text: String) -> Text {
        guard !store(\.searchText).isEmpty, !text.isEmpty else { return Text(text) }
        
        var highlightedText = Text("")
        var currentText = text
        
        while let range = currentText.range(of: store(\.searchText), options: .caseInsensitive) {
            let prefix = String(currentText[..<range.lowerBound])
            let match = String(currentText[range])
            
            highlightedText = highlightedText + Text(prefix)
            highlightedText = highlightedText + Text(match).foregroundColor(.OR6)
            
            currentText = String(currentText[range.upperBound...])
        }
        
        highlightedText = highlightedText + Text(currentText)
        return highlightedText
    }
}
