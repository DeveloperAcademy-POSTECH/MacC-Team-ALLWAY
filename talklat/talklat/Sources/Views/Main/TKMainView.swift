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
                        .foregroundStyle(Color.OR5)
                }
                .padding(.bottom, 50)

                TKOrbitCircles(
                    store: store,
                    circleRenderInfos: [
                        CircleRenderInfo(x: -25, y: -15),
                        CircleRenderInfo(x: 0, y: 27),
                        CircleRenderInfo(x: 25, y: -15),
                    ],
                    circleColor: Color.OR6
                )
                .frame(maxHeight: 200)
                .overlay {
                    Circle()
                        .fill(Color.OR6)
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("TALKLAT")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.OR5)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("ALL HISTORY VIEW HERE")
                } label: {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .foregroundStyle(Color.gray300)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("SETTING VIEW HERE")
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.gray300)
                }
            }
        }
        .background { Color.gray100.ignoresSafeArea(edges: .top) }
    }
    
    private func startConversationButtonBuilder() -> some View {
        Button {
            store.onStartConversationButtonTapped()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.OR6)
                    .opacity(0.3)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.OR6)
                    .frame(width: 100, height: 100)
                
                Image("TKBubble_Main")
                    .foregroundStyle(Color.white)
                    .padding(.top, 12)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .bold()
                    .foregroundStyle(Color.OR6)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TKMainView()
    }
}
