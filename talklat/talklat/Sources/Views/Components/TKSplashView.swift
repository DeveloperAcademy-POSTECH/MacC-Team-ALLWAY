//
//  TKSplashView.swift
//  talklat
//
//  Created by Celan on 11/15/23.
//

import Lottie
import SwiftUI

struct TKSplashView: View {
    @Binding var playbackMode: LottiePlaybackMode
    
    var body: some View {
        LottieView(animation: .named("BDSplash.json"))
            .playbackMode(playbackMode)
            .animationDidFinish { _ in
                playbackMode = .paused
            }
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
