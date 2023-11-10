//
//  TKOrbitCircles.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKOrbitCircles: View {
    struct CircleOffset: Hashable {
        let x: CGFloat
        let y: CGFloat
    }
    
    @State private var isAnimating: Bool = false
    
    private let startingOffset: [CircleOffset] = [
        CircleOffset(x: 37, y: -5),
        CircleOffset(x: -11, y: 42),
        CircleOffset(x: -30, y: -21),
    ]
    
    var body: some View {
        GeometryReader { proxy in
            ForEach(
                startingOffset,
                id: \.self
            ) { offset in
                Group {
                    Circle()
                        .frame(
                            width: proxy.size.width / 2,
                            height: proxy.size.height / 2,
                            alignment: .center
                        )
                        .offset(
                            x: offset.x,
                            y: offset.y
                        )
                        .foregroundStyle(Color.accentColor.opacity(0.3))
                }
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .rotationEffect(
                    self.isAnimating ? .degrees(360) : .zero
                )
                .animation(
                    Animation
                        .linear(duration: 30.0)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            TKOrbitCircles()
                .background { Color.red }
        }
    }
}
