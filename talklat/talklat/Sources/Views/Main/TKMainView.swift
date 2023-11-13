//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKMainView: View {
    @StateObject private var store = TKMainViewStore()
    @StateObject private var conversationView = TKConversationViewStore()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: 120)
                
                VStack(spacing: 10) {
                    HStack(spacing: 2) {
                        Image(systemName: "location.fill")
                        
                        Text("현재 위치")
                    }
                    
                    Text("새 대화 시작하기")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .padding(.bottom, 32)

                TKOrbitCircles(store: store)
                    .frame(maxHeight: 250)
                    .overlay {
                        Circle()
                            .fill(Color.white)
                            .opacity(0.5)
                            .frame(width: 200, height: 200)
                    }
                    .overlay {
                        startConversationButtonBuilder()
                    }
            }
            .frame(
                maxHeight: .infinity,
                alignment: .top
            )
            
            // MARK: BottomSheet
            TKDraggableList(store: store)
        }
        .fullScreenCover(
            isPresented: store.bindingConversationFullScreenCover()
        ) {
            TKConversationView(store: conversationView)
        }
        .toolbarBackground(
            Color.accentColor,
            for: .navigationBar
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("TALKLAT")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.white)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("SETTING VIEW HERE")
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.white)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("ALL HISTORY VIEW HERE")
                } label: {
                    Image(systemName: "list.dash")
                        .foregroundStyle(Color.white)
                }
            }
        }
        .background { Color.accentColor.ignoresSafeArea(edges: .top) }
    }
    
    private func startConversationButtonBuilder() -> some View {
        Button {
            store.onStartConversationButtonTapped()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .opacity(0.3)
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 150, height: 150)
                
                Image(systemName: "bubble.middle.bottom.fill")
                    .resizable()
                    .frame(width: 84, height: 77)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TKMainView()
    }
}
