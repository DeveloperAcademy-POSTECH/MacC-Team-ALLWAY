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
    
    @State public var isHistoryViewShown: Bool = true
    @State private var scrollOffset: CGPoint = .zero
    @State private var deviceHeight: CGFloat = CGFloat(0)
    
    @State private var currentProxyID: Int = 0
  
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                OffsetObservingScrollView(offset: $scrollOffset) {
                    VStack {
                        TKHistoryView(
                            appViewStore: appViewStore,
                            isHistoryViewShown: $isHistoryViewShown,
                            deviceHeight: $deviceHeight
                        )
                        .frame(maxWidth: .infinity)
                        .id("historyView")
                        
                        TKIntroView(
                            appViewStore: appViewStore,
                            deviceHeight: $deviceHeight
                        )
                        .frame(
                            height: geo.size.height + geo.safeAreaInsets.magnitude
                        )
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .id("introView")
                    }
                    .onAppear {
                        withAnimation {
                            appViewStore.onIntroViewAppear(proxy)
                        }
                        
                        
                        deviceHeight = geo.size.height
                        /// ignoreSafeArea()하면 값도 받아오지 못함
                        // deviceTopSafeAreaInset = geo.safeAreaInsets.magnitude
                    }
                    .onChange(of: scrollOffset) { _ in
                        
                        // isHistoryViewShown 로직
                        if scrollOffset.y < 652 {
                            isHistoryViewShown = true
                        } else {
                            isHistoryViewShown = false
                        }
                        
                        // scroll to historyView 로직
//                        if !isHistoryViewShown,
//                           scrollOffset.y < 771 {
//                            proxy.scrollTo("historyView")
//                        }
                        
                        // scroll to introView 로직
//                        if isHistoryViewShown,
//                           scrollOffset.y > 73 {
//                            proxy.scrollTo("introView")
//                        }
                        
                        print("isHistoryViewShown: ", isHistoryViewShown)
                        print("deviceHeight: ", deviceHeight)
                        print("scrollOffset: ", scrollOffset)
                        print("----------------------------")
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
    }
}
    


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
    var axes: Axis.Set = [.vertical]
    var showsIndicators = true
    @Binding var offset: CGPoint
    @ViewBuilder var content: () -> Content
    
    // The name of our coordinate space doesn't have to be
    // stable between view updates
    private let coordinateSpaceName = UUID()
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
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
        .coordinateSpace(name: coordinateSpaceName)
    }
}



//struct NewTestingView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTestingView()
//    }
//}





