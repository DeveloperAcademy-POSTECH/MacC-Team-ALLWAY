//
//  FullScreenCoverBottomView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct FullScreenCoverBottomView: View {
    @State private var scrollOffset: CGPoint = .zero
    @State private var text: String = ""
    
    @Binding var isTopViewShown: Bool
    @Binding var deviceHeight: CGFloat
    @Binding var topInset: CGFloat
    @Binding var bottomInset: CGFloat
    
    @Binding var scrollTotalOffset: CGPoint
    
    var body: some View {
        VStack {
            OffsetObservingScrollView(
                offset: $scrollOffset
            ) {
                VStack(spacing: 10) {
                    ForEach(0 ..< 50) { item in
                        Text("\(item)")
                    }
                    
                    Color.clear
                        .frame(width: 0, height: 0, alignment: .bottom)
                        .frame(width: 0, height: 0, alignment: .bottom)
                        .onAppear {
                            scrollTotalOffset = scrollOffset
                            print("::: offset: ", scrollOffset)
                        }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
            
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity)
        .background(.blue)
        .onChange(of: scrollOffset) { offset in
            print("---> bottom scroll: ", offset)
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.3
            ) {
                if offset.y < -100 {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        isTopViewShown = true
                    }
                }
            }
            print("isTopViewShown: ", isTopViewShown)
        }
    }
}
