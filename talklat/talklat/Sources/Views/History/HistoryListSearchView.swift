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
    
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        Group {
            switch searchStatus {
            case .inactive:
                EmptyView()
                    .background(Color.ExceptionWhiteW8)
                
            case .resultFound:
                ScrollView {
                    // 섹션 타이틀로 사용할 위치 정보 추출
                    let locationList = matchingContents.flatMap {
                        dataStore.getContentBasedLocations(content: $0)
                    }
                    
                    // 중복된 위치 문자열 제거
                    let locationStrings = Array(Set(locationList.map { $0.blockName }))
                    
                    // 위치 정보로 섹션 타이틀 나열
                    ForEach(locationStrings, id: \.self) { string in
                        let matchingLocation = locationList.first { $0.blockName == string }
                        if let location = matchingLocation {
                            SearchResultSection(
                                location: location,
                                dataStore: dataStore,
                                matchingContents: $matchingContents,
                                searchText: $searchText
                            )
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .transition(.identity)
                .background(Color.ExceptionWhiteW8)
                
            case .resultNotFound:
                TKUnavailableViewBuilder(
                    icon: "doc.questionmark.fill",
                    description: NSLocalizedString("noSearchResult", comment: "")
                )
                .transition(.identity)
                .background(Color.ExceptionWhiteW8)
                
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
        .onDisappear {
            searchText = ""
        }
    }
}

// MARK: - (Matching) Location Unit
struct SearchResultSection: View, FirebaseAnalyzable {
    var location: TKLocation
    var dataStore: TKSwiftDataStore
    
    @State private var filteredConversations = Set<TKConversation>()
    @State private var filteredContents = [TKContent]()
    @Binding var matchingContents: [TKContent]
    @Binding var searchText: String
    
    let firebaseStore: any TKFirebaseStore = HistorySearchFirebaseStore()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Location Title
            HStack {
                Image(systemName: "location.fill")
                
                BDText(text: location.blockName, style: .T3_B_125)
                    .foregroundColor(.GR8)
                    .padding(.leading, -5)
                    .lineLimit(1)
                
                Spacer()
                
                BDText(
                    text: "\(filteredConversations.count)\(NSLocalizedString("history.search.found", comment: ""))",
                    style: .H2_M_135
                )
                .foregroundColor(.GR5)
            }
            
            // Contents
            ForEach(Array(filteredContents.enumerated()), id: \.offset) { index, content in
                if let conversation = content.conversation {
                
                    /// 일치하는 위치 타이틀 아래에서만 리스트 생성
                    if conversation.location?.blockName == location.blockName {
                        NavigationLink {
                            CustomHistoryView(
                                historyViewType: .item,
                                // TODO: Store 메서드에서 처리
                                conversation: conversation
                            )
                        } label: {
                            SearchResultItem(
                                matchingContent: content,
                                searchText: $searchText
                            )
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded { _ in
                                    if let conversation = content.conversation {
                                        if let location = conversation.location {
                                            firebaseStore.userDidAction(
                                                .tapped(.item),
                                                .historyType(
                                                    conversation,
                                                    location.blockName
                                                ))
                                        } else {
                                            print("From FirebaseStore: location missing")
                                        }
                                    } else {
                                        print("From firebaseStore: conversationMissing")
                                    }
                                }
                        )
                    }
                } else {
                    Text("Conversation이 없어요!")
                }
            }
            
        }
        .padding(.top, 24)
        .onAppear {
            // TODO: 모든 로직 Store로 분리
            // MARK: - 검색 결과에서 중복된 Conversation 제거 & 시간상 마지막 Conversation 보여주기
            matchingContents.forEach { content in
                if let conversation = content.conversation {
                    filteredConversations.insert(conversation)
                }
            }
            
             // Conversation을 기준으로 그룹핑 된 matchingContents을 담은 딕셔너리
             /// [(TKConversation: [TKContent, TKContent]) ... ]
             let groupedContents = Dictionary(
                 grouping: matchingContents,
                 by: { $0.conversation }
             )
             
             // 그룹핑 된 딕셔너리에서 한 개 이상의 Content가 존재할 경우, 마지막 Content만 필터링 된 배열에 추가
             groupedContents.forEach { (key: TKConversation?, value: [TKContent]) in
                 if value.count > 1 {
                     /// createdAt 기준으로 오름차순 정렬
                     var createdAtArray = value.map { $0.createdAt }
                     createdAtArray.sort(
                         by: { $0.compare($1) == .orderedAscending }
                     )
                     
                     /// 정렬된 배열의 맨 마지막 Content를 필터링 된 배열에 추가
                     value.forEach { content in
                         if content.createdAt == createdAtArray.last {
                             filteredContents.append(content)
                         }
                     }
                 } else {
                     filteredContents.append(contentsOf: value)
                 }
                 
                 // 필터링 된 Content 내림차순 정렬
                 filteredContents.sort(
                     by: { $0.createdAt.compare($1.createdAt) == .orderedDescending }
                 )
             }
        }
        .onChange(of: dataStore.conversations) { oldValue, newValue in
            // 데이터 최신화 (임시방편)
            filteredContents = filteredContents.filter { content in
                dataStore.contents.contains(content)
            }
        }
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
            VStack(alignment: .leading, spacing: -3) {
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
                    style: .C1_SB_130
                )
                .foregroundColor(.GR4)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .padding(.horizontal, 16)
        .cornerRadius(16)
        .onAppear {
            let searchTextKeywords = searchText.split(separator: " ")
        
            // StartingIndex 구하기
            var isCharacterFound: Bool = false
            
            Array(matchingContent.text).forEach { character in
                if !isCharacterFound {
                    if searchTextKeywords[0].contains(character) {
                        highlightIndex = matchingContent.text.firstIndex(
                            of: character
                        ) ?? searchText.startIndex
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
