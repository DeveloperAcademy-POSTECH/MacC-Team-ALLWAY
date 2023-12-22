//
//  SettingTRSearchBar.swift
//  talklat
//
//  Created by 신정연 on 11/15/23.
//

import SwiftUI

struct SettingTRSearchBar: View {
    @ObservedObject var store: TextReplacementViewStore
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            // 검색 텍스트 필드
            AWTextField(
                style: .search,
                text: store.bindingSearchText(),
                placeholder: "검색"
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if !store.viewState.searchText.isEmpty {
                    Button {
                        store.onSearchTextRemoveButtonTapped()
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.GR4)
                    }
                }
            }
            .padding(.vertical, 7)
            .focused($isTextFieldFocused)
            
            if isTextFieldFocused {
                Button {
                    self.hideKeyboard()
                    store.cancelSearchAndHideKeyboard()
                    
                } label: {
                    BDText(
                        text: "취소",
                        style: .H1_B_130
                    )
                }
                .padding(.leading, 8)
            }
        }
    }
}
