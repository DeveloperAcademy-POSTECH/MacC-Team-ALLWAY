//
//  TKBreathingCircles.swift
//  talklat
//
//  Created by Celan on 11/9/23.
//

import SwiftUI

struct TKBreathingCircles: View {
    struct BreathingCircleRender: Hashable {
        let widthDiff: CGFloat
        let opacity: CGFloat
    }
    
    let breathingCircles: [BreathingCircleRender] = [
        BreathingCircleRender(widthDiff: 10, opacity: 0.4),
        BreathingCircleRender(widthDiff: 50, opacity: 0.6),
        BreathingCircleRender(widthDiff: 90, opacity: 1.0),
    ]
    
    @State private var animationFlag: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(
                breathingCircles,
                id: \.self
            ) { circles in
                Group {
                    Circle()
                        .foregroundStyle(Color.BaseBGWhite)
                        .frame(
                            width: abs(proxy.size.width - circles.widthDiff),
                            alignment: .center
                        )
                        .opacity(
                            animationFlag && circles.opacity != 1.0
                            ? circles.opacity / 2
                            : circles.opacity
                        )
                }
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .animation(
                    Animation
                        .easeInOut
                        .speed(0.2)
                        .repeatForever(autoreverses: true),
                    value: animationFlag
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            animationFlag.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        TKBreathingCircles()
            .background { Color.black }
    }
}
