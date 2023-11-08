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
            VStack {
                #warning("LOCATION HERE")
                
                TKOrbitCircles()
                    .overlay {
                        NavigationLink {
                            Text("?")
                        } label: {
                            Circle()
                                .opacity(0.5)
                                .frame(width: 195, height: 195)
                                .overlay {
                                    Text(Constants.START_CONVERSATION_MESSAGE)
                                        .multilineTextAlignment(.center)
                                        .font(.title)
                                        .bold()
                                        .foregroundStyle(.white)
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
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("SETTING VIEW HERE")
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.gray400)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("ALL HISTORY VIEW HERE")
                } label: {
                    Image(systemName: "list.dash")
                        .foregroundStyle(Color.gray400)
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
