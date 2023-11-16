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
    @ObservedObject var store: TextReplacementViewStore
    @Binding var selectedList: TKTextReplacement?
    
    var lists: [TKTextReplacement]
    var textReplacementManager = TKTextReplacementManager()

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

    func highlightSearchText(in text: String) -> Text {
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

    var body: some View {
        List(
            filteredLists,
            id: \.self
        ) { list in
            ForEach(
                list.wordDictionary.sorted { $0.key < $1.key },
                id: \.key
            ) { key, values in
                if let firstValue = values.first {
                    NavigationLink {
                        TKTextReplacementEditView(store: store)
                            .onAppear {
                                selectedList = list
                                
                                store.selectTextReplacement(
                                    phrase: key,
                                    replacement: firstValue
                                )
                            }
                        
                    } label: {
                        VStack(spacing: 0) {
                            highlightSearchText(in: key)
                                .font(.system(size: 17, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineSpacing(17 * 1.3 - 17)
                                .padding(.vertical, 10)
                                .padding(.leading, 16)
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            highlightSearchText(
                                in: firstValue.count > 30
                                ? String(firstValue.prefix(29)) + "..."
                                : firstValue
                            )
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(15 * 1.35 - 15)
                            .padding(.vertical, 10)
                            .padding(.leading, 16)
                        }
                        .background(Color.GR1)
                        .cornerRadius(15)
                    }
                    .cornerRadius(16)
                }
            }
            
            .listRowBackground(Color.GR1)
            .background(Color.BaseBGWhite)
//            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    TKTextReplacementListView()
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
