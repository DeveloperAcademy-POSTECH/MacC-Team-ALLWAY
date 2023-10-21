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
    @State private var scrollOffset: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                OffsetObservingScrollView(
                    appViewStore: appViewStore,
                    offset: $scrollOffset
                ) {
                    VStack {
                        TKHistoryView(appViewStore: appViewStore)
                        .frame(maxWidth: .infinity)
                        .id("historyView")
                        
                        TKIntroView(appViewStore: appViewStore)
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
                    }
                }
                .overlay {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(
                                    appViewStore.isHistoryViewShown
                                    ? Color.clear
                                    : .red
                                )
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
                                        .offset(
                                            y: appViewStore.isMessageTapped
                                            ? 30
                                            : 0
                                        )
                                        .onTapGesture {
                                            withAnimation(
                                                Animation.spring(
                                                    response: 0.24,
                                                    dampingFraction: 0.5,
                                                    blendDuration: 0.8
                                                )
                                                .speed(0.5)
                                            ) {
                                                appViewStore.swipeGuideMessageTapped()
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
                    .safeAreaInset(
                        edge: .top,
                        content: {
                            Rectangle()
                                .fill(.white)
                            // TODO: - deviceTopSafeAreaInset 값으로 변경
                                .frame(height: 50)
                        }
                    )
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                appViewStore.scrollAvailabilityIndicator(false)
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    appViewStore.historyViewIndicator(true)
                                    
                                    appViewStore.scrollDestinationIndicator(
                                        scrollReader: proxy,
                                        destination: "historyView"
                                    )
                                }
                            }
                    )
                }
                .overlay {
                    VStack {
                        Spacer()
                            .frame(maxHeight: .infinity)
                        
                        Rectangle()
                            .fill(
                                appViewStore.isHistoryViewShown
                                ? .blue
                                : Color.clear
                            )
                            .opacity(0.01)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { gesture in
                                appViewStore.scrollAvailabilityIndicator(true)
                                appViewStore.swipeGuideMessageDragged(gesture)
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    appViewStore.scrollDestinationIndicator(
                                        scrollReader: proxy,
                                        destination: "introView"
                                    )
                                    
                                    appViewStore.historyViewIndicator(false)
                                }
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
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
                    value: geometry
                        .frame(in: coordinateSpace)
                        .origin
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



//struct ScrollContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollContainer()
//    }
//}



