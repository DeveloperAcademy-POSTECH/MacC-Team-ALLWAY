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
    var list: TKTextReplacement
    @Binding var selectedList: TKTextReplacement?
    
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
        .background(Color.gray100)
        .cornerRadius(15)
    }
}

struct TextReplacementRow_Previews: PreviewProvider {
    @State static var selectedList: TKTextReplacement?
    
    static var previews: some View {
        TextReplacementRow(key: "Sample Key", value: "Sample Value", list: TKTextReplacement(wordDictionary: ["아이스":"아메리카노"]), selectedList: $selectedList)
    }
}
