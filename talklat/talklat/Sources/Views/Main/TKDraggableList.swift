//
//  TKDraggableList.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKDraggableList: View {
    @ObservedObject var store: TKMainViewStore
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        // MARK: - BOTTOM SHEET BACKGROUND
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.gray100)
                        
                        VStack {
                            Capsule()
                                .fill(Color.gray700)
                                .frame(width: 36, height: 4)
                                .padding(.vertical)
                                .opacity(height - 175 <= abs(lastOffset) ? 0.0 : 1.0)
                                .animation(.easeInOut, value: lastOffset)
                            
                            // MARK: - RECENT CONVERSATION LIST
                            TKRecentConversationListView()
                                .scrollDisabled(!isBottomSheetMaxed(height))
                        }
                    }
                        .offset(y: height - 100)
                        .offset(y: -offset > 100 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                        .gesture(
                            DragGesture()
                                .updating($gestureOffset) { value, out, _ in
                                    out = value.translation.height
                                    onChange()
                                }
                                .onEnded { _ in
                                    let maxHeight = height
                                    
                                    withAnimation(.spring()) {
                                        if -offset > maxHeight / 2 {
                                            offset = -maxHeight
                                        } else {
                                            offset = 0
                                        }
                                    }
                                    
                                    lastOffset = offset
                                })
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func isBottomSheetMaxed(_ height: CGFloat) -> Bool {
        height - 200 <= abs(lastOffset)
    }
}

#Preview {
    TKDraggableList(store: .init())
}
