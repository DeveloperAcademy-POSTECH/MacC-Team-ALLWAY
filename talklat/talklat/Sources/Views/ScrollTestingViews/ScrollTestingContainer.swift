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
            // 임시 내려가기 버튼
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
                     .padding(.bottom, -10)
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
            
            TextFieldView(
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
        .onChange(of: isTopViewShown) { _ in
            if isTopViewShown {
                hideKeyboard()
            }
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
                withAnimation(.linear(duration: 0.5)) {
                    isTopViewShown = true
                }
            }
        }
    }
}


struct TextFieldView: View {
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




struct ScrollTestingContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTestingContainer()
    }
}
