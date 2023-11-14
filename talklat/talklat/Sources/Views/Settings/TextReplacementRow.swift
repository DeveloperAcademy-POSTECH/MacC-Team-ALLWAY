//
//  TextReplacementRow.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftUI

struct TextReplacementRow: View {
    @Binding var selectedList: TKTextReplacement?
    
    var key: String
    var value: String
    var list: TKTextReplacement
    
    var body: some View {
        Button(action: {
            selectedList = list
        }) {
            VStack(spacing: 0) {
                Text(key)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(17 * 1.3 - 17)
                    .padding(.vertical, 10)
                    .padding(.leading, 16)
                
                Divider()
                    .padding(.leading, 16)
                
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(15 * 1.35 - 15)
                    .padding(.vertical, 10)
                    .padding(.leading, 16)
            }
        }
        .background(Color.GR1)
        .cornerRadius(15)
    }
}
