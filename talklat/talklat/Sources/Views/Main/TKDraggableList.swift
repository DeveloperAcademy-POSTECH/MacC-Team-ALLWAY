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
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        // MARK: - BOTTOM SHEET BACKGROUND
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.white)
                        
                        VStack {
                            Capsule()
                                .fill(Color.gray700)
                                .frame(width: 36, height: 4)
                                .padding(.vertical)
                            
                            // MARK: - RECENT CONVERSATION LIST
                            TKRecentConversationListView()
                                .scrollDisabled(!store(\.isBottomSheetMaxed))
                        }
                        .onChange(of: store(\.lastOffset)) { _, _ in
                            store.onBottomSheetMaxed(height - 180)
                        }
                    }
                    .offset(y: height - 180)
                    .offset(
                        y: -store(\.offset) > 180
                        ? -store(\.offset) <= (height - 180)
                        ? store(\.offset)
                        : -(height - 180)
                        : 0
                    )
                    .gesture(
                        DragGesture()
                            .updating($gestureOffset) { value, out, _ in
                                out = value.translation.height
                                store.onUpdatingDragOffset(gestureOffset)
                            }
                            .onEnded { _ in
                                store.onDragEnded(height)
                            })
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

#Preview {
    TKDraggableList(store: .init())
}
