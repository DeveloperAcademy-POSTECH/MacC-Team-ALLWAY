//
//  HistoryListSearchView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

private enum searchStatus {
    case inactive
    case resultFound
    case resultNotFound
}

struct HistoryListSearchView: View {
    var dataStore: TKSwiftDataStore
    
    var sampleConversations: [TKConversationSample]
    
    @State var matchingContents: [TKContent] = [TKContent(
        text: "",
        status: "answer",
        createdAt: Date.now
    )]
    @State private var searchStatus: searchStatus = .inactive
    @Binding internal var isSearching: Bool
    @Binding internal var searchText: String
    
    var body: some View {
        Group {
            switch searchStatus {
            case .inactive:
                EmptyView()
                
            case .resultFound:
                ScrollView {
                    // TODO: matching [TKContent]의 matching [TKConversation.location]
                    ForEach(
                        dataStore.getContentBasedLocations(contents: matchingContents)
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
            // TODO: if else matching TKContent 존재
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
                
                Text(location.blockName)
                    .foregroundColor(.gray800)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, -5)
                
                Spacer()
                
                Text("\(matchingContents.count)개 발견됨")
                    .foregroundColor(.gray500)
                    .font(.system(size: 15, weight: .medium))
            }
            
            // Contents
            ForEach(matchingContents, id: \.self) { content in
                SearchResultItem(
                    matchingContent: content,
                    searchText: $searchText
                )
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
                Text(matchingContent.conversation?.title ?? "Talklat Title")
                    .font(.system(size: 17, weight: .medium))
               
                // 검색 키워드와 일치하는 한 개의 TKContent.text
                let matchingText =  String(matchingContent.text[highlightIndex ..< matchingContent.text.endIndex])
                
                // 임시 ScrollView
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(Array(matchingText.enumerated()), id: \.offset) { character in
                            var isHighlighted: Bool = false
                            if searchText.contains(character.element) {
                                let _ = isHighlighted = true
                            } else {
                                let _ = isHighlighted = false
                            }
                            
                            Text(String(character.element))
                                .foregroundStyle(
                                    isHighlighted
                                    ? Color.accentColor
                                    : Color.black
                                )
                        }
                    }
                }
                
                Text(
                    matchingContent.createdAt.formatted( // TODO: format
                        date: .abbreviated,
                        time: .omitted
                   )
                )
                .foregroundColor(.gray400)
                .font(.system(size: 15, weight: .medium))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray100)
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
