//
//  BDText.swift
//  bisdam
//
//  Created by 신정연 on 11/20/23.
//

import SwiftUI

enum BDTextStyle {
    // MARK: General Type
    // Large Title Styles
    case LT_B_120, LT_SB_120, LT_M_120
    // Title Styles
    case T1_B_120, T1_SB_120, T1_M_120
    case T2_B_125, T2_SB_125, T2_M_125
    case T3_B_125, T3_SB_125, T3_M_125
    // Headline Styles
    case H1_B_130, H1_SB_130, H1_M_130
    case H2_SB_135, H2_M_135
    // Footnote Styles
    case FN_SB_135, FN_M_135
    // Caption Styles
    case C1_SB_130, C1_M_130
    case C2_SB_120
    // MARK: for Conversation+HistoryBubble Type (for C)
    // Large Title Styles
    case LT_B_160, LT_M_160
    // Title Styles
    case T1_B_170, T1_M_170
    case T2_B_160, T2_M_160
    case T3_B_160, T3_M_160
    // Headline Styles
    case H1_B_160, H1_M_160
    case H2_SB_160, H2_M_160
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
            // Large Title Styles
        case .LT_B_120:
            return (Font.custom("Pretendard-Bold", size: 34), .bold, 1.2, 34)
        case .LT_SB_120:
            return (Font.custom("Pretendard-SemiBold", size: 34), .semibold, 1.2, 34)
        case .LT_M_120:
            return (Font.custom("Pretendard-Medium", size: 34), .medium, 1.2, 34)
            
            // Title Styles
        case .T1_B_120:
            return (Font.custom("Pretendard-Bold", size: 28), .bold, 1.2, 28)
        case .T1_SB_120:
            return (Font.custom("Pretendard-SemiBold", size: 28), .semibold, 1.2, 28)
        case .T1_M_120:
            return (Font.custom("Pretendard-Medium", size: 28), .medium, 1.2, 28)
        case .T2_B_125:
            return (Font.custom("Pretendard-Bold", size: 22), .bold, 1.25, 22)
        case .T2_SB_125:
            return (Font.custom("Pretendard-SemiBold", size: 22), .semibold, 1.25, 22)
        case .T2_M_125:
            return (Font.custom("Pretendard-Medium", size: 22), .medium, 1.25, 22)
        case .T3_B_125:
            return (Font.custom("Pretendard-Bold", size: 20), .bold, 1.25, 20)
        case .T3_SB_125:
            return (Font.custom("Pretendard-SemiBold", size: 20), .semibold, 1.25, 20)
        case .T3_M_125:
            return (Font.custom("Pretendard-Medium", size: 20), .medium, 1.25, 20)
            
            // Headline Styles
        case .H1_B_130:
            return (Font.custom("Pretendard-Bold", size: 17), .bold, 1.3, 17)
        case .H1_SB_130:
            return (Font.custom("Pretendard-SemiBold", size: 17), .semibold, 1.3, 17)
        case .H1_M_130:
            return (Font.custom("Pretendard-Medium", size: 17), .medium, 1.3, 17)
        case .H2_SB_135:
            return (Font.custom("Pretendard-SemiBold", size: 15), .semibold, 1.35, 15)
        case .H2_M_135:
            return (Font.custom("Pretendard-Medium", size: 15), .medium, 1.35, 15)
            
            // Footnote Styles
        case .FN_SB_135:
            return (Font.custom("Pretendard-SemiBold", size: 13), .semibold, 1.35, 13)
        case .FN_M_135:
            return (Font.custom("Pretendard-Medium", size: 13), .medium, 1.35, 13)
            
            // Caption Styles
        case .C1_SB_130:
            return (Font.custom("Pretendard-SemiBold", size: 12), .semibold, 1.3, 12)
        case .C1_M_130:
            return (Font.custom("Pretendard-Medium", size: 12), .medium, 1.3, 12)
        case .C2_SB_120:
            return (Font.custom("Pretendard-SemiBold", size: 11), .semibold, 1.2, 11)
            
            // Conversation+HistoryBubble Type (for C)
            // Large Title Styles
        case .LT_B_160:
            return (Font.custom("Pretendard-Bold", size: 34), .bold, 1.6, 34)
        case .LT_M_160:
            return (Font.custom("Pretendard-Medium", size: 34), .medium, 1.6, 34)
            
            
            // Title Styles
        case .T1_B_170:
            return (Font.custom("Pretendard-Bold", size: 28), .bold, 1.45, 28) // 피그마에 비해 행간 1.7 너무 넓어요ㅠㅠ
        case .T1_M_170:
            return (Font.custom("Pretendard-Medium", size: 28), .medium, 1.7, 28)
        case .T2_B_160:
            return (Font.custom("Pretendard-Bold", size: 22), .bold, 1.6, 22)
        case .T2_M_160:
            return (Font.custom("Pretendard-Medium", size: 22), .medium, 1.6, 22)
        case .T3_B_160:
            return (Font.custom("Pretendard-Bold", size: 20), .bold, 1.4, 20)
        case .T3_M_160:
            return (Font.custom("Pretendard-Medium", size: 20), .medium, 1.6, 20)
            
            // Headline Styles
        case .H1_B_160:
            return (Font.custom("Pretendard-Bold", size: 17), .bold, 1.6, 17)
        case .H1_M_160:
            return (Font.custom("Pretendard-Medium", size: 17), .medium, 1.6, 17)
        case .H2_SB_160:
            return (Font.custom("Pretendard-SemiBold", size: 15), .semibold, 1.6, 15)
        case .H2_M_160:
            return (Font.custom("Pretendard-Medium", size: 15), .medium, 1.6, 15)
            
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
            BDText(text: "H1_B_130", style: .H1_B_130)
            BDText(text: "LT_B_120", style: .LT_B_120)
            BDText(text: "FN_SB_135", style: .FN_SB_135)
            BDText(text: "C1_M_130", style: .C1_M_130)
            BDText(text: "라 ㄴ링ㄹ ㄴㅇ라 ㄴ일ㄴ알ㄴㅇ; ㅣㄹㅇ나;ㅣㄹ자ㅣㄹㅈ디ㅏ ㅈ리ㅏㅇ니 ㄷㄹ딪; ㅏㅣ;ㄹㅇ나ㅣ라 ㅣㄴㄹ디ㅏㄹ 니ㅏ;ㅇㄹㄴ;ㅣ아리 안리;ㅏㅣ;리;ㅏ디ㅏ; ㅣ", style: .T1_B_170)
        }
    }
}

struct BDText_Previews: PreviewProvider {
    static var previews: some View {
        BDTextTestView()
    }
}
