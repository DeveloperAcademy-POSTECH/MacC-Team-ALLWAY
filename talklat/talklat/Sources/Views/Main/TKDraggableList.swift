//
//  TKDraggableList.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKDraggableList: View {
    @EnvironmentObject private var locationStore: TKLocationStore
    @ObservedObject var mainViewstore: TKMainViewStore
    @ObservedObject var conversationViewStore: TKConversationViewStore
    @StateObject private var draggableListViewStore: TKDraggableListViewStore = TKDraggableListViewStore()
    @GestureState var gestureOffset: CGFloat = 0
    let firstOffset = UIScreen.main.bounds.height * 0.65
    let dataStore: TKSwiftDataStore = TKSwiftDataStore()
    
    
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
                TKRecentConversationListView(
                    conversationViewStore: conversationViewStore,
                    draggableListViewStore: draggableListViewStore
                )
                    .scrollDisabled(!mainViewstore(\.isBottomSheetMaxed))
                    .scrollIndicators(.hidden)
            }
            .onChange(of: mainViewstore(\.lastOffset)) { _, _ in
                mainViewstore.onBottomSheetMaxed(firstOffset)
            }
            .onChange(of: dataStore.conversations) { _, _ in
                draggableListViewStore.reduce(
                    \.conversations,
                     into: locationStore.getClosestConversation(dataStore.conversations)
                )
            }
            .onChange(of: locationStore(\.authorizationStatus)) { _, _ in
                if locationStore.detectAuthorization() {
                    locationStore.trackUserCoordinate()
                    draggableListViewStore.reduce(
                        \.conversations,
                         into: locationStore.getClosestConversation(dataStore.conversations)
                    )
                }
            }
            .onChange(of: locationStore(\.currentUserCoordinate)) { _, _ in
                //MARK: circularRegion 관찰이 아닌 currentUserCoordinate 관찰 -> 근데 정확도 좀 떨어짐
                draggableListViewStore.reduce(
                    \.conversations,
                     into: locationStore.getClosestConversation(dataStore.conversations)
                )
            }
            .task {
                locationStore.trackUserCoordinate()
                draggableListViewStore.reduce(
                    \.conversations,
                     into: locationStore.getClosestConversation(dataStore.conversations)
                )
            }
        }
        // 시작할 때 보여줄 리스트의 offset
        .offset(y: firstOffset)
        // 유저가 드래그할 때 리스트의 위치를 정하는 offset
        .offset(y: mainViewstore(\.offset))
        // 유저의 드래그가 끝나고 위치를 정하는 offset
        .offset(y: mainViewstore(\.lastOffset))
        .gesture(
            DragGesture()
                .onChanged { value in
                    mainViewstore.onUpdatingDragOffset(value.translation.height)
                }
                .onEnded{ value in
                    mainViewstore.onDragEnded(firstOffset)
                }
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    ZStack {
        Color.yellow
        TKDraggableList(mainViewstore: .init(), conversationViewStore: .init())
    }
}
