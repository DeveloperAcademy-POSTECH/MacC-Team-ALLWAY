//
//  TKOrbitCircles.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKOrbitCircles<TKStore: TKReducer>: View where TKStore.ViewState : TKAnimatable {
    @ObservedObject var store: TKStore
    
    struct CircleRenderInfo: Hashable {
//        let radiusDiff: CGFloat
        let x: CGFloat
        let y: CGFloat
        var bool: Bool {
            return true
        }
    }
    
    private let circleRenderInfos: [CircleRenderInfo] = [
        CircleRenderInfo(/*radiusDiff: 54, */x: -25, y: -15),
        CircleRenderInfo(/*radiusDiff: 54, */x: 0, y: 27),
        CircleRenderInfo(/*radiusDiff: 54, */x: 25, y: -15),
    ]
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(
                circleRenderInfos,
                id: \.self
            ) { offset in
                Group {
                    Circle()
                        .frame(
                            width: proxy.size.width,
                            alignment: .center
                        )
                        .offset(
                            x: offset.x,
                            y: offset.y
                        )
                        .foregroundStyle(Color.white)
                        .opacity(0.3)
                }
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .rotationEffect(
                    store(\.animationFlag) ? .degrees(180) : .zero
                )
                .scaleEffect(
                    store(\.animationFlag) ? 1.0 : 0.85
                )
                .animation(
                    Animation
                        .easeInOut
                        .speed(0.05)
                        .repeatForever(autoreverses: true),
                    value: store(\.animationFlag)
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .task {
            store.triggerAnimation(true)
        }
    }
}

#Preview {
    NavigationStack {
        TKOrbitCircles(store: TKMainViewStore())
            .frame(width: 200, height: 200)
            .background { Color.red }
    }
}
