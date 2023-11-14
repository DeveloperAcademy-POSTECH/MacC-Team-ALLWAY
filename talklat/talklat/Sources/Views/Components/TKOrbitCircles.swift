//
//  TKOrbitCircles.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct CircleRenderInfo: Hashable {
    let x: CGFloat
    let y: CGFloat
}

struct TKOrbitCircles<TKStore: TKReducer>: View where TKStore.ViewState : TKAnimatable {
    @ObservedObject var store: TKStore
    let circleRenderInfos: [CircleRenderInfo]
    let circleColor: Color
    
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
                        .foregroundStyle(circleColor)
                        .opacity(0.3)
                }
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .rotationEffect(
                    store(\.animationFlag) ? .degrees(180) : .degrees(-180)
                )
                .animation(
                    Animation
                        .easeInOut
                        .speed(0.02)
                        .repeatForever(autoreverses: false),
                    value: store(\.animationFlag)
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .task {
            store.triggerAnimation(true)
        }
        .onDisappear {
            store.reduce(\.animationFlag, into: false)
        }
    }
}

#Preview {
    NavigationStack {
        TKOrbitCircles(
            store: TKMainViewStore(),
            circleRenderInfos: [
                CircleRenderInfo(x: -25, y: -15),
                CircleRenderInfo(x: 0, y: 27),
                CircleRenderInfo(x: 25, y: -15),
            ],
            circleColor: .red
        )
            .frame(width: 200, height: 200)
            .background { Color.white}
    }
}
