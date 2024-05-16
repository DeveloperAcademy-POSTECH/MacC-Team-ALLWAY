//
//  TKSplashView.swift
//  talklat
//
//  Created by Celan on 11/15/23.
//

import SwiftUI

struct TKSplashView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Image(.bisdamIcon)
          .resizable()
          .frame(width: 62, height: 62)
    }
}

#Preview {
    TKSplashView()
}
