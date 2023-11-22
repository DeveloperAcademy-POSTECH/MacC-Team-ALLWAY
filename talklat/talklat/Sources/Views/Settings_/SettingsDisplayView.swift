//
//  SettingsDisplayView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

private enum ColorSchemeType: String, CaseIterable {
    case device = "시스템 설정과 동일"
    case light = "밝은 모드"
    case dark = "어두운 모드"
    
    var theme: ColorScheme {
        switch self {
        case .device: return ColorScheme.unspecified
        case .light: return ColorScheme.light
        case .dark: return ColorScheme.dark
        }
    }
}

struct SettingsDisplayView: View {
    @AppStorage("BDColorScheme") var BDColorScheme = ColorScheme.unspecified
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @State private var selectedTheme: ColorScheme = .dark
    
    var body: some View {
        VStack {
            ForEach(ColorSchemeType.allCases, id: \.self) { type in
                BDListCell(label: type.rawValue) {
                } trailingUI: {
                    if selectedTheme == type.theme {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 21))
                    } else {
                        Image(systemName: "circlebadge")
                            .font(.system(size: 26.8))
                    }
                }
                .onTapGesture {
                    selectedTheme = type.theme
                    colorSchemeManager.colorScheme = selectedTheme
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .navigationTitle("화면 모드")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedTheme = colorSchemeManager.colorScheme
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
