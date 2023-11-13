//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

struct TKHistoryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var store: TKConversationViewStore
    
    var body: some View {
        ScrollViewReader { proxy in
            Rectangle()
                .fill(Color.clear)
                .frame(height: 30)
            
            OffsetObservingScrollView(
                offset: store.bindingHistoryScrollOffset()
            ) {
                // TODO: - ForEach의 data 아규먼트 수정
                // TODO: - 각 Color 값을 디자인 시스템 값으로 추후 수정
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
                .padding(.top, 10)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            store.onHistoryViewAppear(geo: geometry)
                        }
                    }
                )
            }
            .onAppear {
                proxy.scrollTo(
                    "lastItem",
                    anchor: .bottom
                )
            }
            .navigationTitle(
                store(\.isTopViewShown)
                ? "히스토리"
                : ""
            )
        }
        .ignoresSafeArea()
        .onChange(of: store(\.historyScrollOffset)) { offset in
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.3
            ) {
                if offset.y > 870,
                   offset.y < 920,
                   store.isAnswerCardDisplayable {
                    store.onScrollOffsetChanged(false)
                }
            }
        }
    }
    
    private func checkColorScheme() -> Color {
        if colorScheme == .light {
            return Color.white
        } else {
            return Color.black
        }
    }
}

extension TKHistoryView {
    private func questionTextBuilder(_ item: HistoryItem) -> some View {
        Text(item.text)
            .font(.subheadline)
            .foregroundColor(.gray700)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray200)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
            .padding(.trailing, 24)
            .padding(.leading, 68)
            .padding(.top, 32)
    }
    
    
    private func answerTextBuilder(_ item: HistoryItem) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "waveform.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.gray700)
                .padding(.leading, 4)
            
            Text(item.text)
                .font(.headline)
                .foregroundColor(.gray700)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.white))
                }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.horizontal, 24)
//        .id(store(\.historyScrollOffset).checkIfLastItem(item))
    }
}
