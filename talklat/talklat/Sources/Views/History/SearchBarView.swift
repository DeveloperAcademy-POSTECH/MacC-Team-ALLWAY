//
//  SearchBarView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

// TODO: 추후 TKTextField로 코드 전부 병합?
struct SearchBarView: View, FirebaseAnalyzable {
    @Binding internal var isSearching: Bool
    @Binding internal var searchText: String
    let firebaseStore: any TKFirebaseStore = HistorySearchFirebaseStore()
    
    var body: some View {
        // Search Bar Area
        HStack {
            AWTextField(
                style: .search,
                text: $searchText,
                placeholder: NSLocalizedString("내용 검색", comment: "")
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.GR4)
            } trailingButton: {
                if isSearching 
                    && !searchText.isEmpty {
                    Button {
                        firebaseStore.userDidAction(.tapped(.eraseAll))
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
                    firebaseStore.userDidAction(.tapped(.cancel))
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
                        text: NSLocalizedString("취소", comment: ""),
                        style: .H1_B_130
                    )
                }
            }
        }
        .onAppear {
            
        }
        .onChange(of: isSearching) { _, _ in
            if isSearching == true {
                firebaseStore.userDidAction(.viewed)
                firebaseStore.userDidAction(
                    .tapped(.field))
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
