//
//  SettingTRSearchBar.swift
//  talklat
//
//  Created by 신정연 on 11/15/23.
//

import SwiftUI

struct SettingTRSearchBar: View {
    @Binding var isSearching: Bool
    @Binding var searchText: String

    var body: some View {
        HStack {
            // 검색 텍스트 필드
            AWTextField(
                style: .search,
                text: $searchText,
                placeholder: "검색"
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if isSearching {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.GR4)
                    }
                }
            }
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    isSearching = true
                }
            }

            if isSearching {
                Button {
                    isSearching = false
                    searchText = ""
                } label: {
                    Text("취소")
                }
            }
        }
    }
}
