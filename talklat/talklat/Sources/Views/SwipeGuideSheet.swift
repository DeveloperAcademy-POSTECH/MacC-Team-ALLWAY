//
//  SwipeGuideSheet.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

public enum SwipeGuideType {
    case swipeToTopWithText
    case swipeToTopWithSymbol
    case swipeToBottom
}

@ViewBuilder
public func swipeGuideSheet(type: SwipeGuideType) -> some View {
    switch type {
    case SwipeGuideType.swipeToTopWithText:
        VStack {
            VStack(spacing: 12) {
                Image(systemName: "chevron.compact.up")
                    .r                            esizable()
                    .frame(width: 32, height: 10)
                    .padding(.bottom, 10)
                
                Text("위로 스와이프해서 내용을 더 확인하세요")
                    .font(.system(size: 12, weight: .bold))
                    .bold()
                    .padding(.top, 24)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: 48,
                alignment: .top
            )
            .foregroundColor(Color(.systemGray))
            .background {
                Rectangle()
                    .fill(Color.white)
//                    .shadow(
//                        color: Color(.systemGray4),
//                        radius: 30,
//                        y: 5
//                    )
            }
        }
        .frame(
            maxHeight: .infinity,
            alignment: .bottom
        )
        
    case SwipeGuideType.swipeToTopWithSymbol:
        VStack {
            VStack(spacing: 12) {
                Image(systemName: "chevron.compact.up")
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
//                    .shadow(
//                        color: Color(.systemGray4),
//                        radius: 30,
//                        y: 5
//                    )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: 32,
            alignment: .bottom
        )
        
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
//                    .shadow(
//                        color: Color(.systemGray4),
//                        radius: 30,
//                        y: 5
//                    )
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
        swipeGuideSheet(type: .swipeToBottom)
    }
}
