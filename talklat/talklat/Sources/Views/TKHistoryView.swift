//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

struct TKHistoryView: View {
    @Environment(\.colorScheme)
    var colorScheme
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        ScrollView {
            // TODO: - ForEach의 data 아규먼트 수정
            // TODO: - 각 Color 값을 디자인 시스템 값으로 추후 수정
            ForEach(
                appViewStore.historyItems,
                id: \.id
            ) { item in
                switch item.type {
                case .question:
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
                    
                case .answer:
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
                }
            }
        }
        .padding(.top, 16)
        .safeAreaInset(edge: .bottom) {
            VStack {
                VStack(spacing: 12) {
                    Text("텍스트 작성 페이지로 돌아가기")
                        .font(.system(size: 12, weight: .bold))
                        .bold()
                        .padding(.top, 24)
                    
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .frame(width: 32, height: 10)
                        .padding(.bottom, 10)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 100,
                    alignment: .top
                )
                .foregroundColor(Color.gray500)
                .background {
                    Rectangle()
                        .fill(
                            colorScheme == .light
                            ? Color.white
                            : Color.black
                        )
                        .shadow(
                            color: Color.gray300,
                            radius: 25,
                            y: -1
                        )
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background { Color.gray100 }
        .navigationTitle("히스토리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color(.systemGray6),
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
    }
}

struct TKHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TKHistoryView(appViewStore: .makePreviewStore(condition: { store in
                store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
                store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
                
            }))
        }
    }
}
