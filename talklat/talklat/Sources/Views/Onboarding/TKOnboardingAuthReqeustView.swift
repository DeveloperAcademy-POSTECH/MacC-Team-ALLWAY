//
//  TKOnboardingAuthReqeustView.swift
//  talklat
//
//  Created by Celan on 11/16/23.
//

import SwiftUI

struct TKOnboardingAuthReqeustView: View {
    @Binding var parentInfo: TKOnboardingView.OnboardingInfo
    let info: TKOnboardingView.OnboardingInfo
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack(spacing: 15) {
                Circle()
                    .frame(width: 34, height: 34)
                
                Text("\(info.title).")
                    .font(.largeTitle)
                    .bold()
            }
            .foregroundStyle(Color.OR6)
            .padding(.bottom, 36)
            
            Text("\(info.description)")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
                .lineSpacing(16)
            
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .transition(
            .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        )
        .onAppear {
            self.parentInfo = info
        }
    }
}
