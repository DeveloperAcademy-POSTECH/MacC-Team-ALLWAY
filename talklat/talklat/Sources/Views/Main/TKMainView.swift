//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKMainView: View {
    #warning("Location Manager Here")
    @StateObject private var store = TKMainViewStore()
    
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
                
                TKBreathingCircles()
                    .frame(maxHeight: 250)
                    .overlay {
                        NavigationLink {
                            ScrollContainer()
                                .navigationBarBackButtonHidden()
                        } label: {
                            ZStack {
                                Image(systemName: "bubble.middle.bottom.fill")
                                    .resizable()
                                    .frame(width: 84, height: 77)
                                
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .frame(width: 40, height: 10)
                                    .foregroundStyle(Color.white)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
            }
            .frame(
                maxHeight: .infinity,
                alignment: .top
            )
            
            // MARK: BottomSheet
            TKDraggableList(store: store)
        }
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
}

#Preview {
    NavigationStack {
        TKMainView()
    }
}
