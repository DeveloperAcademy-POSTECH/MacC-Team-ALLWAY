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
                placeholder: "내용 검색"
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if isSearching 
                    && !searchText.isEmpty {
                    Button {
                        // Remove All
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.GR4)
                    }
                }
            }
            
            if isSearching {
                Button {
                    // Dismiss Search UI
                    withAnimation(
                        .spring(
                            dampingFraction: 0.8,
                            blendDuration: 0.9
                        )
                    ) {
                        isSearching = false
                    }
                    
                    searchText = ""
                } label: {
                    BDText(
                        text: "취소",
                        style: .H1_B_130
                    )
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
