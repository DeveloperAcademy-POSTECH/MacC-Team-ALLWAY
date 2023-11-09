//
//  TKMainView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKMainView: View {
    @StateObject private var store = TKMainViewStore()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: 120)
                
                HStack(spacing: 2) {
                    Image(systemName: "location.fill")
                    
                    Text("${CURRENT_LOCATION}")
                }
                .font(.caption)
                .bold()
                .foregroundStyle(Color.gray)
                .padding(.bottom, 10)
                
                Text("새 대화 시작하기")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.white)
                    
                ZStack {
                    TKBreathingCircles()
                    
                    NavigationLink {
                        Text("?")
                    } label: {
                        Image(systemName: "ellipsis.message.fill")
                            .resizable()
                            .frame(maxWidth: 86, maxHeight: 77)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 250)
                .padding(.top, 32)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            
            // MARK: BottomSheet
            TKDraggableList(store: store)
        }
        .background { Color.accentColor.ignoresSafeArea(edges: .top) }
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
    }
}

#Preview {
    NavigationStack {
        TKMainView()
    }
}
