//
//  TextReplacementRow.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftUI

struct TextReplacementRow: View {
    var key: String
    var value: String
    var lineLimit: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            BDText(text: key, style: .H1_B_130)
                .lineLimit(1)
                .foregroundStyle(Color.GR9)
                .foregroundStyle(Color.GR7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 11)
                .padding(.leading, 16)
            
            Divider()
                .padding(.leading, 16)
            
            BDText(text: value, style: .H2_SB_135)
                .lineLimit(lineLimit)
                .foregroundStyle(Color.GR5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TextReplacementRow(key: "hi", value: "yes")
        .background { Color.yellow }
}
