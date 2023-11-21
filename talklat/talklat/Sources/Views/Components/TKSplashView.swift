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
        HStack {
            Image("bisdam_icon")
                .resizable()
                .frame(width: 92, height: 92)
                .grayscale(animateFlag ? 0.0 : 1.0)
                .opacity(animateFlag ? 1.0 : 0.0)
            
            Image("bisdam_typo")
                .resizable()
                .frame(width: 160, height: 77)
                .opacity(animateFlag ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity)
        .animation(
            .default
                .delay(0.2)
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
