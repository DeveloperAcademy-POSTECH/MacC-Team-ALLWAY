//
//  TKText.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/10.
//

import Foundation
import SwiftUI

// MARK: - Talklat Text Design System
public enum TKTextStyle {
    case bodyText
    case subtitleText
    case placeHolderText
}

@ViewBuilder
public func TKText(style: TKTextStyle, _ string: String) -> some View {
    switch style {
    case .bodyText:
        Text(string)
            .font(.system(size: 34))
            .fontWeight(.bold)
            .lineSpacing(180 / 10)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        
    case .subtitleText:
        Text(string)
            .font(.system(size: 17))
            .fontWeight(.medium)
            .opacity(0.5)
            .lineSpacing(5)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        
    case .placeHolderText:
        Text(string)
            .font(.system(size: 34))
            .fontWeight(.semibold)
            .opacity(0.3)
            .lineSpacing(180 / 10)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}

struct TestingView: View {
    var body: some View {
        VStack {
            TKText(
                style: .subtitleText,
                "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오"
            )
        }
    }
}


struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}

private func guideMessageBuilder() -> some View {
    Text(Constants.GUIDE_MESSAGE)
        .font(.largeTitle)
        .bold()
        .kerning(2)
        .lineSpacing(10)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 24)
        .padding(.top, 40)
        .foregroundColor(.gray)
}


