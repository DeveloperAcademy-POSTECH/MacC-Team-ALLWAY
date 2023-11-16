//
//  TKUnavailableViewBuilder.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/9/23.
//

import SwiftUI

// MARK: - Custom ContentUnavailableView Builder
@ViewBuilder
func TKUnavailableViewBuilder(
    icon: String,
    description: String
) -> some View {
    ZStack {
        Color.clear
            .ignoresSafeArea()
        
        VStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .foregroundColor(.GR2)
            
            Text(description)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.GR3)
        }
    }
}

#Preview {
    TKUnavailableViewBuilder(
        icon: "circle",
        description: "동그라미밖에 없어요.."
    )
}
