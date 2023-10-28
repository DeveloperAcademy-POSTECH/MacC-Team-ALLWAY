//
//  TestingTKHistoryView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct TestingTKHistoryView: View {
    @Environment(\.colorScheme)
    var colorScheme
    @ObservedObject var appViewStore: AppViewStore
    
    @Binding var isTopViewShown: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            Rectangle()
                .fill(Color.clear)
                .frame(height: 30)
            
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
                        .id(appViewStore.checkIfLastItem(item))
                    }
                }
                .padding(.top, 10)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            appViewStore.historyScrollViewHeight = geometry.size.height
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
            // TODO: - deviceTopSafeAreaInset 값으로 변경
//            .padding(.top, 100)
            .background { Color(.systemGray6) }
            .background { Color.gray100 }
            .navigationTitle(
                appViewStore.isHistoryViewShown
                ? "히스토리"
                : ""
            )
        }
        .onChange(
            of: appViewStore.historyScrollOffset
        ) { offset in
            print("---> history offset: ", offset)
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.3
            ) {
                if offset.y > 870 && offset.y < 920 {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        isTopViewShown = false
                    }
                }
            }
            print("---> isTopViewShown: ", isTopViewShown)
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

struct TestingTKHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TKHistoryView(appViewStore: .makePreviewStore(condition: { store in
            store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
            store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .question))
            store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
        }))
    }
}
