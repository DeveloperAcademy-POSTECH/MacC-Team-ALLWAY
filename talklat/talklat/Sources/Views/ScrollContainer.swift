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
    
    var body: some View {
        GeometryReader { geo in /// TKIntroView가 디바이스 height를 차지하도록 사용
            ScrollViewReader { proxy in /// 스크롤 위치 이동시 proxy 사용
                OffsetObservingScrollView(
                    offset: $appViewStore.containerScrollOffset) {
                        VStack {
                            TKHistoryView(appViewStore: appViewStore)
                                .frame(
                                    height: geo.size.height + geo.safeAreaInsets.magnitude
                                )
                                .id("TKHistoryView")
                            
                            TKIntroView(appViewStore: appViewStore)
                                .padding(.top, -10) /// View 사이의 디폴트 공백 제거
                                .frame(
                                    height: geo.size.height + geo.safeAreaInsets.magnitude
                                )
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .id("TKIntroView")
                        }
                        .onAppear {
                            appViewStore.onIntroViewAppear(proxy)
                            appViewStore.deviceHeight = geo.size.height
                        }
                        .onChange(of: appViewStore.containerScrollOffset) { offset in
                            if appViewStore.isHistoryViewShown { // TKHistoryView
                                print("offset: ", offset)
                                
                                // 화면 전환이 끝났는지 파악
                                if offset.y == -0.0 {
                                    appViewStore.hasHistoryTransitionEnded = true
                                }
                                print("hasContainerScrollEnded: ", appViewStore.hasHistoryTransitionEnded)
                            
                                if appViewStore.hasHistoryTransitionEnded {
                                    if offset.y > 0 {
                                        appViewStore.scrollAvailabilitySetter(
                                            isDisabled: true
                                        )
                                        appViewStore.scrollDestinationSetter(
                                            scrollReader: proxy,
                                            destination: "TKHistoryView"
                                        )
                                        
                                        DispatchQueue.main.asyncAfter(
                                            deadline: .now() + 0.3
                                        ) {
                                            appViewStore.scrollAvailabilitySetter(
                                                isDisabled: false
                                            )
                                            print("!!!!!!다시측정시작!!!!!!")
                                        }
                                    }
                                }
                            } else { // TKHistoryView
                                if offset.y < appViewStore.deviceHeight {
                                    appViewStore.scrollAvailabilitySetter(
                                        isDisabled: true
                                    )
                                    appViewStore.scrollDestinationSetter(
                                        scrollReader: proxy,
                                        destination: "TKIntroView"
                                    )
                                    
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 0.3
                                    ) {
                                        appViewStore.scrollAvailabilitySetter(
                                            isDisabled: false
                                        )
                                        print("!!!!!!다시측정시작!!!!!!")
                                    }
                                } 
                            }
                        }
                        .onChange(of: appViewStore.historyScrollOffset) { _ in
                            if appViewStore.isHistoryViewShown {
                                appViewStore.scrollAvailabilitySetter(isDisabled: false)
                                print("!!!!!풀림!!!!!!!")
                                print("historyView scroll offset: ", appViewStore.historyScrollOffset)
                            }
                        }
                    }
                    .scrollDisabled(appViewStore.isScrollDisabled)
                    // MARK: - 전체 overlay
//                    .overlay {
//                        if !appViewStore.isHistoryViewShown {
//                            Rectangle()
//                                .fill(.orange)
//                                .opacity(0.01)
//                                .frame(
//                                    maxWidth: .infinity,
//                                    maxHeight: .infinity
//                                )
////                                .gesture(
////                                    DragGesture()
////                                        .onChanged { gesture in
////                                            appViewStore.scrollAvailabilitySetter(
////                                                isDisabled: false
////                                            )
////                                        }
////                                        .onEnded { gesture in
////                                            print("~~~~")
////                                            withAnimation {
////                                                hideKeyboard()
////                                                appViewStore.historyViewSetter(true)
////                                                appViewStore.scrollDestinationSetter(
////                                                    scrollReader: proxy,
////                                                    destination: "TKHistoryView"
////                                                )
////                                            }
////                                        }
////                                )
//                        }
//                    }
                    // MARK: - 상단 스와이프 영역
                    .overlay {
                        if appViewStore.communicationStatus == .writing,
                            appViewStore.historyItems.count != 0
                        {
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .fill(.red)
                                        .opacity(0.5)
                                    
                                    VStack {
                                        ZStack(alignment: .top) {
                                            Text("위로 스와이프해서 내용을 더 확인하세요")
                                                .font(.system(size: 11))
                                                .foregroundColor(Color(.systemGray2))
                                                .opacity(
                                                    appViewStore.isMessageTapped
                                                    ? 1.0
                                                    : 0.0
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
                                        appViewStore.scrollAvailabilitySetter(
                                            isDisabled: false
                                        )
                                    }
                                    .onEnded { gesture in
                                        withAnimation {
                                            hideKeyboard()
                                            appViewStore.historyViewSetter(true)
                                            appViewStore.scrollDestinationSetter(
                                                scrollReader: proxy,
                                                destination: "TKHistoryView"
                                            )
                                        }
                                    }
                            )
                            
                        }
                        
                    }
                    // MARK: - 하단 스와이프 영역
                    .overlay {
                        if appViewStore.isHistoryViewShown == true {
                            VStack {
                                Spacer()
                                    .frame(maxHeight: .infinity)
                                
                                Rectangle()
                                    .fill(.blue)
                                    .opacity(0.5)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                            }
                            // .ignoresSafeArea()
                            .gesture(
                                DragGesture(minimumDistance: 1)
                                    .onChanged { gesture in
                                        appViewStore.scrollAvailabilitySetter(
                                            isDisabled: true
                                        )
                                        appViewStore.swipeGuideMessageDragged(gesture)
                                    }
                                    .onEnded { gesture in
                                        withAnimation {
                                            appViewStore.scrollDestinationSetter(
                                                scrollReader: proxy,
                                                destination: "TKIntroView"
                                            )
                                            
                                            appViewStore.historyViewSetter(false)
                                        }
                                    }
                            )
                        }
                    }
            }
            .scrollIndicators(.hidden)
            .onChange(of: appViewStore.containerScrollOffset) { _ in
                print(">>> containerScrollOffset: ", appViewStore.containerScrollOffset)
                print("---------------------------")
            }
        }
        .ignoresSafeArea()
    }
}


// MARK: - Offset Observing ScrollView
/// 뷰 내부에서 현재 콘텐츠 오프셋을 읽을 수 있는 커스텀 스크롤 뷰
struct OffsetObservingScrollView<Content: View>: View {
    @Binding private(set) var offset: CGPoint
    @ViewBuilder private(set) var content: () -> Content
    
    var body: some View {
        ScrollView {
            PositionObservingView(
                /// 하위 뷰에서 받아온 좌표 값을 스크롤 오프셋 값으로 변환
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                content: content,
                coordinateSpace: .named("coordinate")
            )
        }
        .coordinateSpace(name: "coordinate")
    }
}

// MARK: - Coordinate Position Observing View
/// 주어진 좌표계 내에서 자신의 위치를 읽고 관찰할 수 있는 하위 뷰
struct PositionObservingView<Content: View>: View {
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content
    
    var coordinateSpace: CoordinateSpace
    
    var body: some View {
        content()
            .background(
                GeometryReader { geometry in
                    /// .preference() : PreferenceKey에 값 넣기
                    Color.clear.preference(
                        key: PreferenceKey.self,
                        value: geometry
                            .frame(in: coordinateSpace)
                            .origin
                    )
                }
            )
        /// .onPreferenceChange() : PreferenceKey에서 값 가져오기
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
    
    // MARK: - PreferenceKey
    /// 좌표 위치 값을 비동기로 뷰에 전달 + 해당 값을 position 바인딩에 할당하게 해줌
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        static func reduce(
            value: inout CGPoint,
            nextValue: () -> CGPoint
        ) {
            /// 구현 생략 가능
        }
    }
}




struct ScrollContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollContainer(appViewStore: .makePreviewStore(condition: { store in
                store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
                store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
            }))
        }
    }
}
