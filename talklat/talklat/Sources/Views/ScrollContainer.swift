//
//  NewTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

struct ScrollContainer: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appViewStore: AppViewStore
    
    @State public var scrollOffset: CGPoint = .zero
    @State public var deviceHeight: CGFloat = CGFloat(0)
    @State public var isHistoryViewShown: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                OffsetObservingScrollView(
                    appViewStore: appViewStore,
                    offset: $scrollOffset
                ) {
                    VStack {
                        TKHistoryView(
                            appViewStore: appViewStore,
                            isHistoryViewShown: $appViewStore.isHistoryViewShown,
                            deviceHeight: $appViewStore.deviceHeight
                        )
                        .frame(maxWidth: .infinity)
                        .id("historyView")
                        
                        TKIntroView(
                            appViewStore: appViewStore,
                            deviceHeight: $appViewStore.deviceHeight
                        )
                        .padding(.top, -10) // View 사이의 디폴트 공백 제거
                        .frame(
                            height: geo.size.height + geo.safeAreaInsets.magnitude
                        )
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .id("introView")
                    }
                    .onAppear {
                        appViewStore.onIntroViewAppear(proxy)
                        appViewStore.deviceHeight = geo.size.height
                        /// ignoreSafeArea()하면 값도 받아오지 못함
                        // deviceTopSafeAreaInset = geo.safeAreaInsets.magnitude
                    }
                    .onChange(of: scrollOffset) { _ in
//                        appViewStore.historyViewIndicator()
//                        appViewStore.scrolledToIntroView(proxy)
//                        appViewStore.scrolledToHistoryView(proxy)
                        
//                        print("isHistoryViewShown: ", appViewStore.isHistoryViewShown)
//                        print("deviceHeight: ", appViewStore.deviceHeight)
//                        print("scrollOffset: ", appViewStore.scrollOffset)
//                        print("----------------------------")
                    }
                }
                .overlay {
                    VStack {
                        Rectangle() // SafeAreaInset 역할
                            .fill(.white)
                            // FIXME: deviceTopSafeAreaInset 값으로 변경
                            .frame(height: 40)
                        
                        ZStack {
                            Rectangle()
                                .fill(appViewStore.isHistoryViewShown ? Color.clear : .red)
                                .opacity(0.001)
                            
                            VStack {
                                ZStack(alignment: .top) {
                                    Text("위로 스와이프해서 내용을 더 확인하세요")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(.systemGray2))
                                        .opacity(
                                            appViewStore.isMessageTapped ? 1.0 : 0.0
                                        )
                                        .padding(.top, 10)
                                    
                                    swipeGuideMessage(type: .swipeToTop)
                                        .offset(y: appViewStore.isMessageTapped ? 30 : 0)
                                        .onTapGesture {
                                            withAnimation(
                                                Animation.spring(
                                                    response: 0.24,
                                                    dampingFraction: 0.5,
                                                    blendDuration: 0.8
                                                )
                                                .speed(0.5)
                                            ) {
                                                appViewStore.isMessageTapped = true
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    appViewStore.isMessageTapped = false
                                                }
                                            }
                                        }
                                }
                               
                            }
                            // .background(.red) // 스와이프 메세지 탭 영역 확인
                            .frame(height: 50)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                print("위로 올라가는 드래그 됨!")
                                appViewStore.isScrollDisabled = false
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    print("위로 올라가는 드래그 끝~")
                                    appViewStore.isHistoryViewShown = true
                                    
                                    // 뷰 전환
                                    proxy.scrollTo("historyView", anchor: .top)
                                    
                                    print("isHistoryViewShown: ", appViewStore.isHistoryViewShown)
                                    print("isScrolledDisabled: ", appViewStore.isScrollDisabled)
                                }
                            }
                    )
                }
                .overlay {
                    VStack {
                        Spacer()
                            .frame(maxHeight: .infinity)
                        
                        Rectangle()
                            .fill(appViewStore.isHistoryViewShown ? .blue : Color.clear)
                            .opacity(0.01)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { gesture in
                                print("밑으로 내려가는 드래그 됨!")
                                appViewStore.isScrollDisabled = true
                                
                                // offset 애니메이션
                                if gesture.translation.height > -50 {
                                    appViewStore.messageOffset.height = gesture.translation.height
        
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        appViewStore.messageOffset.height = .zero
                                    }
                                }
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    print("밑으로 내려가는 드래그 끝~")
                                    
                                    // 뷰 전환
                                    proxy.scrollTo("introView", anchor: .top)
                                    appViewStore.isHistoryViewShown = false
                                    
                                    print(appViewStore.isHistoryViewShown)
                                    
                                    print("isHistoryViewShown: ", appViewStore.isHistoryViewShown)
                                    print("isScrolledDisabled: ", appViewStore.isScrollDisabled)
                                }
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: appViewStore.isHistoryViewShown) { isHistoryViewShown in
//                if isHistoryViewShown == true {
//                    appViewStore.isScrollDisabled = false
//                } else {
//                    appViewStore.isScrollDisabled = true
//                }
            }

        }
        .ignoresSafeArea()
    }
}
    

// .onPreferenceChange에 값 넣기
struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

// PreferenceKey:
private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        static func reduce(
            value: inout CGPoint,
            nextValue: () -> CGPoint
        ) { }
    }
}


struct OffsetObservingScrollView<Content: View>: View {
    private(set) var axes: Axis.Set = [.vertical]
    private(set) var showsIndicators = true
   
    @ObservedObject var appViewStore: AppViewStore
    
    @Binding private(set) var offset: CGPoint
    @ViewBuilder private(set) var content: () -> Content
    
    var body: some View {
        ScrollView(
            axes,
            showsIndicators: showsIndicators
        ) {
            PositionObservingView(
                coordinateSpace: .named("talklat"),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                content: content
            )
        }
        .scrollDisabled(appViewStore.isScrollDisabled)
        .coordinateSpace(name: "talklat")
        
    }
}



//struct NewTestingView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTestingView()
//    }
//}



