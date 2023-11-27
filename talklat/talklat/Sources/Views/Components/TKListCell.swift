//
//  TKListCell.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

struct TKListCell<LabelIcon: View, TrailingUI: View>: View {
    private var label: String
    private var leadingIcon: LabelIcon
    private var trailingUI: TrailingUI
    
    var body: some View {
        HStack {
            leadingIcon
                .foregroundColor(.OR6)
                .font(.system(size: 15))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .foregroundColor(.GR8)
                    .font(.system(size: 17, weight: .bold))
            }
            
            Spacer()
            
            trailingUI
                .foregroundColor(.OR6)
                .tint(.OR6)
                .font(.system(size: 13, weight: .semibold))
        }
        .frame(maxWidth: .infinity) // TODO: maxHeight 지정
        .padding(.vertical, 19)
        .padding(.horizontal, 20)
        .background(Color.GR1)
        .cornerRadius(16)
    }
    
    init(
        label: String = "",
        @ViewBuilder leadingIcon: () -> LabelIcon,
        @ViewBuilder trailingUI: () -> TrailingUI
    ) {
        self.label = label
        self.leadingIcon = leadingIcon()
        self.trailingUI = trailingUI()
    }
}

#Preview {
    VStack {
        TKListCell(label: "리스트 아이템 1") {
            Image(systemName: "sun.max.fill")
        } trailingUI: {
            Image(systemName: "chevron.right")
        }
        
        TKListCell(label: "리스트 아이템 2") {
        } trailingUI: {
            Toggle("", isOn: .constant(true))
        }
    }
    .padding(.horizontal, 16)
}
