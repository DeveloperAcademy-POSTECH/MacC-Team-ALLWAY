//
//  ScrollOffsetObserver.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/2/23.
//

import SwiftUI

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
