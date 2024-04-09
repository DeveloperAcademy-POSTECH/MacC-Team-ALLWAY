//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

struct TKHistoryView: View, FirebaseAnalyzable {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var store: TKConversationViewStore
    let firebaseStore: any TKFirebaseStore = ConversationPreviewFirebaseStore()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(
                    store(\.historyItems),
                    id: \.id
                ) { item in
                    switch item.type {
                    case .question:
                        questionTextBuilder(item)
                        
                    case .answer:
                        answerTextBuilder(item)
                    }
                }
                .frame(maxHeight: .infinity)
                .onAppear {
                    proxy.scrollTo(
                        "lastItem",
                        anchor: .top
                    )
                }
                
                Divider()
                    .id("lastItem")
                    .hidden()
                    .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .padding(.bottom, 16)
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .toolbar {
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: "대화 내용",
                    style: .H1_B_130
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            if store(\.isTopViewShown) {
                Button {
                    firebaseStore.userDidAction(
                        .tapped,
                        "goToTypingView",
                        nil
                    )
                    store.onDismissPreviewChevronButtonTapped()
                } label: {
                    VStack(spacing: 8) {
                        BDText(text: "작성 화면으로 돌아가기", style: .FN_SB_135)
                        
                        Image(systemName: "chevron.compact.down")
                            .resizable()
                            .frame(width: 32, height: 10)
                            .bold()
                        
                    }
                }
            } else {
                EmptyView()
            }
        }
        .background { Color.BaseBGWhite }
    }
}

extension TKHistoryView {
    private func questionTextBuilder(_ item: HistoryItem) -> some View {
        BDText(text: item.text, style: .H2_SB_160)
            .foregroundColor(Color.GR7)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.GR1)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
            .padding(.trailing, 16)
            .padding(.leading, 76)
            .padding(.top, 32)
    }
    
    private func answerTextBuilder(_ item: HistoryItem) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "waveform.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.OR5)
                .padding(.leading, 4)
            
            BDText(text: item.text, style: .H2_SB_160)
                .foregroundColor(Color.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.OR5)
                }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        TKHistoryView(store: .init())
    }
}

