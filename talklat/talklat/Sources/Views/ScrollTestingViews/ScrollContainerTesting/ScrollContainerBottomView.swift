//
//  ScrollContainerBottomView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct ScrollContainerBottomView: View {
    @State private var scrollOffset: CGPoint = .zero
    @State private var text: String = ""
    
    @Binding var isTopViewShown: Bool
    @Binding var deviceHeight: CGFloat
    @Binding var topInset: CGFloat
    @Binding var bottomInset: CGFloat
    
    var body: some View {
        VStack {
            OffsetObservingScrollView(
                offset: $scrollOffset
            ) {
                VStack(spacing: 10) {
                    ForEach(0 ..< 50) { item in
                        Text("\(item)")
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
            
            if offset.y < -120 {
                withAnimation(.linear(duration: 0.5)) {
                    isTopViewShown = true
                }
            }
        }
    }
}
