//
//  TKDraggableList.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKDraggableList: View {
    @ObservedObject var store: TKMainViewStore
    @GestureState var gestureOffset: CGFloat = 0
    let firstOffset = UIScreen.main.bounds.height * 0.65
    
    var body: some View {
        ZStack {
            // MARK: - BOTTOM SHEET BACKGROUND
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.SheetBGWhite)
            
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.GR3)
                    .frame(width: 36, height: 5)
                    .padding(.top, 6)
                    .padding(.bottom, 20)
                
                // MARK: - RECENT CONVERSATION LIST
                TKRecentConversationListView()
                    .scrollDisabled(!store(\.isBottomSheetMaxed))
                    .scrollIndicators(.hidden)
            }
            .onChange(of: store(\.lastOffset)) { _, _ in
                store.onBottomSheetMaxed(firstOffset)
            }
        }
        // 시작할 때 보여줄 리스트의 offset
        .offset(y: firstOffset)
        // 유저가 드래그할 때 리스트의 위치를 정하는 offset
        .offset(y: store(\.offset))
        // 유저의 드래그가 끝나고 위치를 정하는 offset
        .offset(y: store(\.lastOffset))
        .gesture(
            DragGesture()
                .onChanged { value in
                    store.onUpdatingDragOffset(value.translation.height)
                }
                .onEnded{ value in
                    store.onDragEnded(firstOffset)
                }
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
}

#Preview {
    ZStack {
        Color.yellow
        TKDraggableList(store: .init())
    }
}
