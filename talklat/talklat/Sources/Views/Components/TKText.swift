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
    case body
    case subtitle
    case placeHolder
}

@ViewBuilder
public func TKText(
    style: TKTextStyle,
    _ string: String
) -> some View {
    switch style {
    case .body:
        Text(string)
            .font(.system(size: 34))
            .fontWeight(.bold)
            .lineSpacing(180 / 10)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        
    case .subtitle:
        Text(string)
            .font(.system(size: 17))
            .fontWeight(.medium)
            .opacity(0.5)
            .lineSpacing(5)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        
    case .placeHolder:
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
                style: .subtitle,
                "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오"
            )
            
            TKText(
                style: .body,
                "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오"
            )
            
            TKText(
                style: .placeHolder,
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
