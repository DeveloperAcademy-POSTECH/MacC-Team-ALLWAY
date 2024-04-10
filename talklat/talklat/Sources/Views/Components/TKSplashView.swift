//
//  TKSplashView.swift
//  talklat
//
//  Created by Celan on 11/15/23.
//

import Lottie
import SwiftUI

struct TKSplashView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var playbackMode: LottiePlaybackMode
    
    var body: some View {
        LottieView(
            animation:
                colorScheme == .light
            ? .named("BDSplash_Light")
            : .named("BDSplash_Dark")
        )
        .playbackMode(playbackMode)
        .animationDidFinish { _ in
            playbackMode = .paused
        }
        .background(Color.ExceptionWhiteW8)
        .onAppear {
            playbackMode = .playing(
                .fromProgress(
                    0,
                    toProgress: 1,
                    loopMode: .playOnce
                )
            )
        }
    }
}

#Preview {
    TKSplashView(playbackMode: .constant(.paused))
}
