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
             TKHistoryView(
                 appViewStore: AppViewStore(
                     communicationStatus: .writing,
                     questionText: "String",
                     currentAuthStatus: .authCompleted
                 )
             )
             .overlay {
                 VStack {
                     Spacer()
                     
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
             }
            
//            TopView(
//                isTopViewShown: $isTopViewShown,
//                deviceHeight: $deviceHeight,
//                topInset: $topInset,
//                bottomInset: $bottomInset
//            )
            .frame(
                height: isTopViewShown
                ? currentViewHeight + bottomInset + topInset // 임시방편
                : nil
            )
            
            BottomView(
                isTopViewShown: $isTopViewShown,
                deviceHeight: $deviceHeight,
                topInset: $topInset,
                bottomInset: $bottomInset
            )
            .frame(
                height: isTopViewShown
                ? nil
                : currentViewHeight + topInset + bottomInset + topInset // 임시방편
            )
        }
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
            print("device: ", deviceHeight)
            print("topInset: ", topInset)
            print("bottomInset: ", bottomInset)
            print("-----------------")
        }
    }
}


struct TopView: View {
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

struct BottomView: View {
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
                withAnimation(.spring(dampingFraction: 0.7)) {
                    isTopViewShown = true
                }
//                withAnimation(.easeIn(duration: 0.2)) {
//                    isTopViewShown = true
//                }
            }
        }
    }
}




struct ScrollTestingContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTestingContainer()
    }
}
