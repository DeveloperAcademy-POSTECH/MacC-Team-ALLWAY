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
                    ForEach(1 ..< 10) { _ in
                        SearchResultSection()
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
                    // TODO: if else matching TKContent 존재
                    searchStatus = .resultFound
                }
            }
        }
    }
}

// MARK: - (Matching) Location Unit
struct SearchResultSection: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            // Location Title
            HStack {
                Image(systemName: "location.fill")
                
                Text("서울특별시 송파동") // TODO: location.blockName
                    .foregroundColor(.gray800)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, -5)
                
                Spacer()
                
                Text("~개 발견됨") // TODO: matching [TKContent].count
                    .foregroundColor(.gray500)
                    .font(.system(size: 15, weight: .medium))
            }
            
            // Contents
            ForEach(1 ..< 3) { _ in // TODO: matching [TKContent]
                SearchResultItems()
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - (Matching) Conversation Item Unit
struct SearchResultItems: View {
    
    var body: some View {
        // Cell Contents
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Title") // TODO: title
                    .font(.system(size: 17, weight: .medium))
               
                Text("아이스 아메리카노 한 잔 주시겠사와요 저는 보통 그란데 사이즈를 먹는데 하지만") // TODO: matching TKContent
                    .foregroundColor(.gray700)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(1)
                
                Text(
                    Date().formatted( // TODO: createdAt
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

    }
}

#Preview {
    HistoryListSearchView(
        isSearching: .constant(true),
        searchText: .constant("ㅇ")
    )
}
