//
//  BDText.swift
//  bisdam
//
//  Created by 신정연 on 11/20/23.
//

import SwiftUI

enum BDTextStyle {
    
    // MARK: General Type (G-Type)
    // 22pt (T2)
    case _22T2_B, _22T2_R
    // 20pt (T3 -> H1)
    case _20H1_B, _20H1_R
    // 17pt (H1 -> H)
    case _17H_B, _17H_R
    // 15pt (H2)
    case _15H2_SMB, _15H2_R
    // 13pt (FN -> F)
    case _13F_M
    
    // MARK: Conversation Type (C-Type)
    // 34pt (LT)
    case _34LT_EXB
    // 28pt (T1)
    case _28T1_B
    // 20pt (H1)
    case _20H1_SMB
}

struct BDText: View {
    let text: String
    private var style: BDTextStyle
    
    init(
        text: String,
        style: BDTextStyle
    ){
        self.text = text
        self.style = style
    }
    
    var body: some View {
        let (font, weight, lineHeightMultiplier, fontSize) = propertiesForStyle(style)
        let lineSpacing = calculateLineSpacing(for: fontSize, with: lineHeightMultiplier)
        let verticalPadding = calculateVerticalPadding(for: fontSize, with: lineHeightMultiplier)
        
        Text(text)
            .font(font)
            .fontWeight(weight)
            .lineSpacing(lineSpacing)
            .padding(.vertical, verticalPadding)
    }
    
    private func propertiesForStyle(_ style: BDTextStyle) -> (Font, Font.Weight, CGFloat, CGFloat) {
        switch style {
            // MARK: G-Type
            // 22pt (T2)
        case ._22T2_B:
            return (Font.custom("Pretendard-Bold", size: 22), .bold, 1.3, 22)
        case ._22T2_R:
            return (Font.custom("Pretendard-Medium", size: 22), .regular, 1.3, 22)
            // 20pt (H1)
        case ._20H1_B:
            return (Font.custom("Pretendard-Bold", size: 20), .bold, 1.3, 20)
        case ._20H1_R:
            return (Font.custom("Pretendard-Medium", size: 20), .regular, 1.3, 20)
            // 17pt (H)
        case ._17H_B:
            return (Font.custom("Pretendard-Bold", size: 17), .bold, 1.3, 17)
        case ._17H_R:
            return (Font.custom("Pretendard-Medium", size: 17), .regular, 1.3, 17)
            // 15pt (H2)
        case ._15H2_SMB:
            return (Font.custom("Pretendard-SemiBold", size: 15), .semibold, 1.3, 15)
        case ._15H2_R:
            return (Font.custom("Pretendard-Medium", size: 15), .regular, 1.3, 15)
            // 13pt (F)
        case ._13F_M:
            return (Font.custom("Pretendard-Medium", size: 13), .medium, 1.3, 13)
            
            
            // MARK: C-Type
            // 34pt (LT)
        case ._34LT_EXB:
            return (Font.custom("Pretendard-ExtraBold", size: 34), .black, 1.7, 34)
            // 28pt (T1)
        case ._28T1_B:
            return (Font.custom("Pretendard-Bold", size: 28), .bold, 1.7, 28)
            // 20pt (H1)
        case ._20H1_SMB:
            return (Font.custom("Pretendard-SemiBold", size: 20), .semibold, 1.7, 20)

        }
    }
    
    // 피그마 기준 LineHeight 계산
    private func calculateLineSpacing(for fontSize: CGFloat, with lineHeightMultiplier: CGFloat) -> CGFloat {
        return fontSize * lineHeightMultiplier - fontSize
    }
    
    private func calculateVerticalPadding(for fontSize: CGFloat, with lineHeightMultiplier: CGFloat) -> CGFloat {
        return (fontSize * lineHeightMultiplier - fontSize) / 2
    }
}


// Test View
struct BDTextTestView: View {
    var body: some View {
        VStack {
            BDText(text: "_17H_B", style: ._17H_B)
            BDText(text: "_34LT_EXB", style: ._34LT_EXB)
            BDText(text: "라 ㄴ링ㄹ ㄴㅇ라 ㄴ일ㄴ알ㄴㅇ; ㅣㄹㅇ나;ㅣㄹ자ㅣㄹㅈ디ㅏ ㅈ리ㅏㅇ니 ㄷㄹ딪; ㅏㅣ;ㄹㅇ나ㅣ라 ㅣㄴㄹ디ㅏㄹ 니ㅏ;ㅇㄹㄴ;ㅣ아리 안리;ㅏㅣ;리;ㅏ디ㅏ; ㅣ", style: ._28T1_B)
        }
    }
}

struct BDText_Previews: PreviewProvider {
    static var previews: some View {
        BDTextTestView()
    }
}
