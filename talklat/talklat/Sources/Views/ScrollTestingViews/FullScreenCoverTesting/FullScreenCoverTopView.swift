//
//  FullScreenCoverTopView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct FullScreenCoverTopView: View {
    @State private var scrollOffset: CGPoint = .zero
    
    @Binding var isTopViewShown: Bool
    @Binding var deviceHeight: CGFloat
    @Binding var topInset: CGFloat
    @Binding var bottomInset: CGFloat
    
    var body: some View {
        VStack {
            OffsetObservingScrollView(
                offset: $scrollOffset
            ) {
                Spacer()
                    .frame(height: 150)
                
                VStack(spacing: 10) {
                    ForEach(0 ..< 50) { item in
                        Text("\(item)")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .onChange(of: scrollOffset) { offset in
                print("---> top scroll: ", offset)
            }
            
            Button {
                isTopViewShown = false
            } label: {
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .frame(width: 32, height: 10)
                    .foregroundColor(.gray500)
            }
            .padding(.vertical, 50)
        }
        .background(.red)
    }
}
