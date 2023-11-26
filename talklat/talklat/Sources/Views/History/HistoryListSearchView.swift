//
//  HistoryListSearchView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

private enum SearchStatus {
    case inactive
    case resultFound
    case resultNotFound
}

struct HistoryListSearchView: View {
    var dataStore: TKSwiftDataStore
    
    @State var matchingContents: [TKContent] = [TKContent(
        text: "",
        type: .answer,
        createdAt: Date.now
    )]
    @State private var searchStatus: SearchStatus = .inactive
    @Binding internal var isSearching: Bool
    @Binding internal var searchText: String
    
    var body: some View {
        Group {
            switch searchStatus {
            case .inactive:
                EmptyView()
                
            case .resultFound:
                ScrollView {
                    ForEach(
                        dataStore.getContentBasedLocations(
                            contents: matchingContents
                        )
                    ) { location in
                        SearchResultSection(
                            location: location,
                            matchingContents: $matchingContents,
                            searchText: $searchText
                        )
                    }
                }
                .scrollIndicators(.hidden)
                .transition(.identity)
                
            case .resultNotFound:
                TKUnavailableViewBuilder(
                    icon: "doc.questionmark.fill",
                    description: "검색 결과가 없어요"
                )
                .transition(.identity)
                
                Spacer()
            }
        }
        .onChange(of: searchText) { _, _ in
            withAnimation {
                // Search Status
                if searchText == "" {
                    searchStatus = .inactive
                } else {
                    if matchingContents.isEmpty {
                        searchStatus = .resultNotFound
                    }
                }
            }
            
            // Search Filter
            matchingContents = []
            
            let matchingContent = dataStore.contents.filter({ content in
                content.text.contains(searchText)
            })
            
            matchingContents.append(contentsOf: matchingContent)
            
        }
        .onChange(of: matchingContents) { _, _ in
            // Search Status Switching
            if !matchingContents.isEmpty {
                searchStatus = .resultFound
            } else {
                if searchText != "" {
                    searchStatus = .resultNotFound
                } else {
                    searchStatus = .inactive
                }
            }
        }
    }
}

// MARK: - (Matching) Location Unit
struct SearchResultSection: View {
    var location: TKLocation
    
    @Binding var matchingContents: [TKContent]
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Location Title
            HStack {
                Image(systemName: "location.fill")
                
                BDText(text: location.blockName, style: .T3_B_125)
                    .foregroundColor(.GR8)
                    .padding(.leading, -5)
                
                Spacer()
                
                BDText(
                    text: "\(matchingContents.count)개 발견됨",
                    style: .H2_M_135
                )
                .foregroundColor(.GR5)
            }
            
            // Contents
            ForEach(matchingContents, id: \.self) { content in
                NavigationLink {
                    if let conversation = content.conversation {
                        CustomHistoryView(
                            historyViewType: .item,
                            // TODO: Store 메서드에서 처리
                            conversation: conversation
                        )
                    } else {
                        Text("Conversation이 없어요!")
                    }
                    
                } label: {
                    SearchResultItem(
                        matchingContent: content,
                        searchText: $searchText
                    )
                }
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - (Matching) Conversation Item Unit
struct SearchResultItem: View {
    var matchingContent: TKContent
    
    @State var highlightIndex: String.Index = String.Index(utf16Offset: 0, in: "")
    @Binding var searchText: String
    
    var body: some View {
        // Cell Contents
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                BDText(
                    text: matchingContent.conversation?.title ?? "BISDAM TITLE",
                    style: .H1_B_130
                )
                .foregroundStyle(Color.GR8)
                
                // 검색 키워드와 일치하는 한 개의 TKContent.text
                let matchingText =  String(
                    matchingContent.text[highlightIndex ..< matchingContent.text.endIndex]
                )
                
                // 임시 ScrollView
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(
                            Array(matchingText.enumerated()),
                            id: \.offset
                        ) { character in
                            var isHighlighted: Bool = false
                            if searchText.contains(character.element) {
                                let _ = isHighlighted = true
                            } else {
                                let _ = isHighlighted = false
                            }
                            
                            BDText(
                                text: String(character.element),
                                style: .H2_M_135
                            )
                                .foregroundStyle(
                                    isHighlighted
                                    ? Color.OR6
                                    : Color.GR5
                                )
                        }
                    }
                }
                
                BDText(
                    text: matchingContent.createdAt.convertToDate(),
                    style: .H2_M_135
                )
                .foregroundColor(.GR4)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.GR1)
        .cornerRadius(22)
        .onAppear {
            let searchTextKeywords = searchText.split(separator: " ")
        
            // StartingIndex 구하기
            var isCharacterFound: Bool = false
            
            Array(matchingContent.text).forEach { character in
                if !isCharacterFound {
                    if searchTextKeywords[0].contains(character) {
                        highlightIndex = matchingContent.text.firstIndex(of: character) ?? searchText.startIndex
                        isCharacterFound = true
                    }
                }
            }
        }

    }
}

//#Preview {
//    HistoryListSearchView(
//        sampleConversations: [TKConversation],
//        isSearching: .constant(true),
//        searchText: .constant("ㅇ")
//    )
//}
