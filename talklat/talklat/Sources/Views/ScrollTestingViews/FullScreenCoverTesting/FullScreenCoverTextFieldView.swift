//
//  FullScreenCoverTextFieldView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct FullScreenCoverTextFieldView: View {
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
                TLTextField(
                    style: .normal(textLimit: 160),
                    text: $text,
                    placeholder: "탭해서 전하고 싶은 내용을 작성해주세요.",
                    leadingButton: {
                        Button {
                            text = ""
                        } label: {
                            Text("전체 지우기")
                        }
                    }
                )
                .padding(.top, 24)
            }
        }
        .safeAreaInset(edge: .top, content: {
            Spacer()
                .frame(height: topInset)
        })
        .frame(maxHeight: .infinity)
        .background(Color.gray200)
        .onChange(of: scrollOffset) { offset in
            print("---> bottom scroll: ", offset)
            
            if offset.y < -120 {
                withAnimation(.spring(dampingFraction: 0.7)) {
                    isTopViewShown = true
                }
            }
        }
    }
}
