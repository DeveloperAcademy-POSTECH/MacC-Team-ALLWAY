//
//  ScrollTestingContainer.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/25.
//

import SwiftUI

struct ScrollTestingContainer: View {
    @State private var deviceHeight: CGFloat = 0
    @State private var topInset: CGFloat = 0
    @State private var bottomInset: CGFloat = 0
    @State private var currentViewHeight: CGFloat = 0
    
    @State private var isTopViewShown: Bool = false
    
    var body: some View {
        VStack {
            TopView(
                isTopViewShown: $isTopViewShown
            )
            .frame(
                height: isTopViewShown
                ? currentViewHeight
                : nil
            )
            
            BottomView(
                isTopViewShown: $isTopViewShown
            )
            .frame(
                height: isTopViewShown
                ? nil
                : currentViewHeight
            )
        }
        .ignoresSafeArea()
        .background {
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        deviceHeight = geo.size.height
                        topInset = geo.safeAreaInsets.top
                        bottomInset = geo.safeAreaInsets.bottom
                    }
            }
        }
        .onAppear {
            currentViewHeight = deviceHeight + topInset + bottomInset
        }
    }
}


struct TopView: View {
    @State private var scrollOffset: CGPoint = .zero
    
    @Binding var isTopViewShown: Bool
    
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
            .background(.red)
            .onChange(of: scrollOffset) { offset in
                print("---> top scroll: ", offset)
            }
            
            Button(action: {
                isTopViewShown = false
            }, label: {
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .frame(width: 32, height: 10)
                    .foregroundColor(.gray500)
            })
        }
    }
}

struct BottomView: View {
    @State private var scrollOffset: CGPoint = .zero
    @State private var text: String = ""
    
    @Binding var isTopViewShown: Bool
    
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
            
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
        }
        .background(.blue)
        .onChange(of: scrollOffset) { offset in
            print("---> bottom scroll: ", offset)
            
            if offset.y < -100 {
                isTopViewShown = true
            }
        }
    }
}




struct ScrollTestingContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTestingContainer()
    }
}
