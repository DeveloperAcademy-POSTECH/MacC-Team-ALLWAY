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
            Text("\(info.title).")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.OR6)
                .padding(.bottom, 36)
            
            AttributedText(
                str: info.description,
                searched: info.highlightTarget
            )
            .font(.title2)
            .bold()
            .multilineTextAlignment(.leading)
            .lineSpacing(10)
            .padding(.bottom, 20)
            
            Text(Constants.Onboarding.CHANGE_AUTH_GUIDE)
                .font(.subheadline)
                .foregroundStyle(Color.GR4)
            
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
                removal: .move(edge: .leading).combined(with: .opacity.animation(.easeInOut))
            )
        )
        .onAppear {
            self.parentInfo = info
        }
    }
    
    private func AttributedText(
        str: String,
        searched: [String]
    ) -> Text {
        var attributed = AttributedString(str)
        
        for search in searched {
            if let range = attributed.range(of: search) {
                attributed[range].foregroundColor = .OR6
            }
        }
        
        return Text(attributed)
    }
}

#Preview {
    TKOnboardingView(authManager: .init())
}
