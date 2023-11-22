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
        let (font, weight, lineHeightMultiplier) = propertiesForStyle(style)
        let lineSpacing = calculateLineSpacing(for: font, with: lineHeightMultiplier)
        let verticalPadding = calculateVerticalPadding(for: font, with: lineHeightMultiplier)
        
        Text(text)
            .font(font)
            .fontWeight(weight)
            .lineSpacing(lineSpacing)
            .padding(.vertical, verticalPadding)
    }
    
    private func propertiesForStyle(_ style: BDTextStyle) -> (Font, Font.Weight, CGFloat) {
        switch style {
        // Large Title Styles
        case .LT_B_120:
            return (.largeTitle, .bold, 1.2)
        case .LT_SB_120:
            return (.largeTitle, .semibold, 1.2)
        case .LT_M_120:
            return (.largeTitle, .medium, 1.2)

        // Title Styles
        case .T1_B_120:
            return (.title, .bold, 1.2)
        case .T1_SB_120:
            return (.title, .semibold, 1.2)
        case .T1_M_120:
            return (.title, .medium, 1.2)
        case .T2_B_125:
            return (.title2, .bold, 1.25)
        case .T2_SB_125:
            return (.title2, .semibold, 1.25)
        case .T2_M_125:
            return (.title2, .medium, 1.25)
        case .T3_B_125:
            return (.title3, .bold, 1.25)
        case .T3_SB_125:
            return (.title3, .semibold, 1.25)
        case .T3_M_125:
            return (.title3, .medium, 1.25)

        // Headline Styles
        case .H1_B_130:
            return (.headline, .bold, 1.3)
        case .H1_SB_130:
            return (.headline, .semibold, 1.3)
        case .H1_M_130:
            return (.headline, .medium, 1.3)
        case .H2_SB_135:
            return (.subheadline, .semibold, 1.35)
        case .H2_M_135:
            return (.subheadline, .medium, 1.35)

        // Footnote Styles
        case .FN_SB_135:
            return (.footnote, .semibold, 1.35)
        case .FN_M_135:
            return (.footnote, .medium, 1.35)

        // Caption Styles
        case .C1_SB_130:
            return (.caption, .semibold, 1.3)
        case .C1_M_130:
            return (.caption, .medium, 1.3)
        case .C2_SB_120:
            return (.caption2, .semibold, 1.2)

        // Conversation+HistoryBubble Type (for C)
        // Large Title Styles
        case .LT_B_160:
            return (.largeTitle, .bold, 1.6)
        case .LT_M_160:
            return (.largeTitle, .medium, 1.6)

        // Title Styles
        case .T1_B_170:
            return (.title, .bold, 1.7)
        case .T1_M_170:
            return (.title, .medium, 1.7)
        case .T2_B_160:
            return (.title2, .bold, 1.6)
        case .T2_M_160:
            return (.title2, .medium, 1.6)
        case .T3_B_160:
            return (.title3, .bold, 1.6)
        case .T3_M_160:
            return (.title3, .medium, 1.6)

        // Headline Styles
        case .H1_B_160:
            return (.headline, .bold, 1.6)
        case .H1_M_160:
            return (.headline, .medium, 1.6)
        case .H2_SB_160:
            return (.subheadline, .semibold, 1.6)
        case .H2_M_160:
            return (.subheadline, .medium, 1.6)
        }
    }


    // 피그마 기준 LineHeight 계산
    private func calculateLineSpacing(for font: Font, with lineHeightMultiplier: CGFloat) -> CGFloat {
        let fontHeight = fontHeight(for: font)
        return fontHeight * lineHeightMultiplier - fontHeight
    }

    private func calculateVerticalPadding(for font: Font, with lineHeightMultiplier: CGFloat) -> CGFloat {
        let fontHeight = fontHeight(for: font)
        return (fontHeight * lineHeightMultiplier - fontHeight) / 2
    }

    private func fontHeight(for font: Font) -> CGFloat {
        switch font {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        default:
            return 17
        }
    }

}

// Test View
struct BDTextTestView: View {
    var body: some View {
        VStack {
            BDText(text: "H1_B_130", style: .H1_B_130)
            BDText(text: "FN_SB_135", style: .FN_SB_135)
            BDText(text: "C1_M_130", style: .C1_M_130)
        }
    }
}

struct BDText_Previews: PreviewProvider {
    static var previews: some View {
        BDTextTestView()
    }
}
