//
//  TKBreathingCircles.swift
//  talklat
//
//  Created by Celan on 11/9/23.
//

import SwiftUI

struct TKBreathingCircles: View {
    struct BreathingCircleRender: Hashable {
        let frame: CGFloat
        let opacity: CGFloat
    }
    
    let breathingCircles: [BreathingCircleRender] = [
        BreathingCircleRender(frame: 240, opacity: 0.4),
        BreathingCircleRender(frame: 200, opacity: 0.6),
        BreathingCircleRender(frame: 160, opacity: 1.0),
    ]
    
    @State private var animationFlag: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(breathingCircles, id: \.self) { circle in
                Circle()
                    .foregroundStyle(Color.white)
                    .opacity(
                        animationFlag && circle.opacity != 1.0
                        ? circle.opacity / 2
                        : circle.opacity
                    )
                    .frame(
                        maxWidth: circle.frame,
                        maxHeight: circle.frame
                    )
                    .animation(
                        .easeInOut
                            .speed(0.2)
                            .repeatForever(autoreverses: true),
                        value: animationFlag
                    )
            }
            .frame(
                maxWidth: proxy.size.width,
                maxHeight: proxy.size.height,
                alignment: .center
            )
        }
        .onAppear {
            animationFlag.toggle()
        }
    }
}

#Preview {
    TKBreathingCircles()
}
