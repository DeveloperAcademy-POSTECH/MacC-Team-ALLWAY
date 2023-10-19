//
//  SwipeGuideSheet.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

public enum SwipeGuideType {
    case swipeToTop
    case swipeToBottom
}

@ViewBuilder
public func swipeGuideMessage(type: SwipeGuideType) -> some View {
    switch type {
    case SwipeGuideType.swipeToTop:
        VStack {
            VStack(spacing: 12) {
                Image(systemName: "chevron.compact.up")
                    .resizable()
                    .frame(width: 32, height: 10)
                    .padding(.bottom, 10)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: 10,
                alignment: .top
            )
            .foregroundColor(Color(.systemGray))
        }
        .frame(alignment: .bottom)
        
    case SwipeGuideType.swipeToBottom:
        VStack {
            VStack(spacing: 12) {
                Text("텍스트 작성 페이지로 돌아가기")
                    .font(.system(size: 12, weight: .bold))
                    .bold()
                    .padding(.top, 24)
                
                Image(systemName: "chevron.compact.down")
                    .resizable()
                    .frame(width: 32, height: 10)
                    .padding(.bottom, 10)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: 100,
                alignment: .top
            )
            .foregroundColor(Color(.systemGray))
            .background {
                Rectangle()
                    .fill(Color.white)
            }
        }
        .frame(
            maxHeight: .infinity,
            alignment: .bottom
        )
    }
}

struct SwipeGuideSheet_Previews: PreviewProvider {
    static var previews: some View {
        swipeGuideMessage(type: .swipeToBottom)
    }
}
