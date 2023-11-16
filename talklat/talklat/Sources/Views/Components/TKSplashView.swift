//
//  TKSplashView.swift
//  talklat
//
//  Created by Celan on 11/15/23.
//

import SwiftUI

struct TKSplashView: View {
    @State private var animateFlag: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.OR5)
                    .frame(width: 35)
                    .offset(y: -10)
                    .opacity(
                        animateFlag
                        ? 1.0
                        : 0.0
                    )
                
                Color.OR6
                    .opacity(0.6)
                    .mask {
                        Image("TALKLAT_BUBBLE")
                            .resizable()
                            .frame(
                                width: 35,
                                height: 41
                            )
                    }
                    .offset(
                        y: animateFlag
                        ? 10
                        : -5
                    )
            }
            .frame(
                width: 50,
                height: 80
            )
            .padding(.trailing, 18)
            
            Image("TALKLAT_TYPO")
                .resizable()
                .frame(width: 215, height: 36)
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity)
        .animation(
            .default
                .delay(0.3)
                .speed(0.30),
            value: animateFlag
        )
        .onAppear {
            animateFlag.toggle()
        }
    }
}

#Preview {
    TKSplashView()
}
