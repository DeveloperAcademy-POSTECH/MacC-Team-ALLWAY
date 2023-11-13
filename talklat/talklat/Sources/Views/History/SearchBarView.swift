//
//  SearchBarView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

// TODO: 추후 TKTextField로 코드 전부 병합?
struct SearchBarView: View {
    @Binding internal var isSearching: Bool
    @Binding internal var searchText: String
    
    var body: some View {
        // Search Bar Area
        HStack {
            AWTextField(
                style: .search,
                text: $searchText,
                placeholder: "검색"
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray400)
            } trailingButton: {
                if isSearching {
                    Button {
                        // Remove All
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray400)
                    }
                }
            }
            
            if isSearching {
                Button {
                    // Dismiss Search UI
                    isSearching = false
                    searchText = ""
                } label: {
                    Text("취소")
                }
            }
        }
    }
}

#Preview {
    SearchBarView(
        isSearching: .constant(true),
        searchText: .constant("안녕")
    )
}