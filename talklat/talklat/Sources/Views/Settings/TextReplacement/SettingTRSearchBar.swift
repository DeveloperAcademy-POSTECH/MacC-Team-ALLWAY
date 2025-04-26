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
                placeholder: NSLocalizedString("settings.textReplacement.search.placeholder", comment: "")
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
                        text: NSLocalizedString("취소", comment: ""),
                        style: ._17H_B
                    )
                }
                .padding(.leading, 8)
            }
        }
    }
}
