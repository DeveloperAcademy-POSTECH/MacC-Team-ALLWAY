//
//  SettingsListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/13/23.
//

import SwiftUI

struct SettingsListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("서울특별시 송파동")
                    .foregroundColor(.gray800)
                    .font(.system(size: 20, weight: .bold))
                
                // Each Setting Cell
                ForEach(1 ..< 3, id: \.self) { _ in
                    SettingItem()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SettingItem: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("dddd")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.gray400)
                    .font(.system(size: 15, weight: .medium))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray100)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsListView()
}
