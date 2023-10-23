//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

import SwiftUI

struct TKHistoryView: View {
    @Environment(\.colorScheme)
    var colorScheme
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        OffsetObservingScrollView(
            offset: $appViewStore.historyScrollOffset
        ) {
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
//                    .id(
//                        appViewStore.historyItems.last == item
//                        ? item.text
//                        : "lastItem"
//                    )
                }
            }
            .padding(.top, 10)
            .background(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        appViewStore.historyScrollViewHeight = proxy.size.height
                        print("---> historyScrollViewHeight", appViewStore.historyScrollViewHeight)
                    }
                }
            )
        }
        .onChange(of: appViewStore.historyScrollOffset, perform: { _ in
            print(">>> historyScrollOffset: ", appViewStore.historyScrollOffset)
        })
        // TODO: - deviceTopSafeAreaInset 값으로 변경
        .padding(.top, 100)
        .background { Color(.systemGray6 )}
        .safeAreaInset(edge: .bottom) {
            VStack {
                swipeGuideMessage(type: .swipeToBottom)
                    .offset(appViewStore.messageOffset)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 100,
                        alignment: .top
                    )
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
                                y: -5
                            )
                    }
            }
        }
        .ignoresSafeArea(edges: .top)
        .background { Color.gray100 }
        .navigationTitle(
            appViewStore.isHistoryViewShown ? "히스토리" : ""
        )
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
        TKHistoryView(appViewStore: .makePreviewStore(condition: { store in
            store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
            store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
        }))
        
        //        NavigationStack {
        //            ScrollContainer(appViewStore: .makePreviewStore(condition: { store in
        //                store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
        //                store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
        //                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
        //                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
        //                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
        //                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
        //
        //            }))
        //        }
    }
}
