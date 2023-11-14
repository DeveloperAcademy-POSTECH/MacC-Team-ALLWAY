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
    @ObservedObject var settingStore = SettingViewStore(settingState: .init())
    @Binding var selectedList: TKTextReplacement?
    
    var searchText: String
    var lists: [TKTextReplacement]
    var textReplacementManager = TKTextReplacementManager()

    var filteredLists: [TKTextReplacement] {
        if searchText.isEmpty {
            return []
        } else {
            return lists.filter { list in
                let searchTextLowercased = searchText.lowercased()
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

    func highlightSearchText(in text: String, search: String) -> Text {
        guard !search.isEmpty, !text.isEmpty else { return Text(text) }

        var highlightedText = Text("")
        var currentText = text

        while let range = currentText.range(of: search, options: .caseInsensitive) {
            let prefix = String(currentText[..<range.lowerBound])
            let match = String(currentText[range])

            highlightedText = highlightedText + Text(prefix)
            highlightedText = highlightedText + Text(match).foregroundColor(.accentColor)

            currentText = String(currentText[range.upperBound...])
        }

        highlightedText = highlightedText + Text(currentText)
        return highlightedText
    }

    var body: some View {
        List(filteredLists, id: \.self) { list in
            VStack(alignment: .leading) {
                ForEach(list.wordDictionary.sorted { $0.key < $1.key }, id: \.key) { key, values in
                    if let firstValue = values.first {
                        Button {
                            selectedList = list
                        } label: {
                            VStack(spacing: 0) {
                                highlightSearchText(in: key, search: searchText)
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineSpacing(17 * 1.3 - 17)
                                    .padding(.vertical, 10)
                                    .padding(.leading, 16)
                                
                                Divider()
                                    .padding(.leading, 16)

                                highlightSearchText(in: firstValue.count > 30 ? String(firstValue.prefix(29)) + "..." : firstValue, search: searchText)
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
                        .simultaneousGesture(TapGesture().onEnded {
                            settingStore.selectTextReplacement(phrase: key, replacement: firstValue)
                        })
                    }
                }
                
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
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
        .background(Color.white)
        .onAppear {
            print("Filtered Lists: \(filteredLists)")
        }
    }
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

// 더미 데이터를 위한 TKTextReplacement 객체들을 생성합니다.
let sampleTKTextReplacements = [
    TKTextReplacement(wordDictionary: ["안녕": ["Hello", "Hi"]]),
    TKTextReplacement(wordDictionary: ["사과": ["Apple"]]),
    TKTextReplacement(wordDictionary: ["책": ["Book"]])
]

struct TKTextReplacementSearchView_Previews: PreviewProvider {
    // 프리뷰를 위한 selectedList 상태 바인딩
    @State static var selectedList: TKTextReplacement?

    static var previews: some View {
        // TKTextReplacementSearchView 인스턴스를 생성하고 필요한 데이터와 바인딩을 제공합니다.
        TKTextReplacementSearchView(
            selectedList: $selectedList,
            searchText: "안녕",
            lists: sampleTKTextReplacements
        )
    }
}
