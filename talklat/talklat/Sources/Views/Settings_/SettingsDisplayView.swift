//
//  SettingsDisplayView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

struct SettingsDisplayView: View {
    enum DisplayMode: String, CaseIterable {
        case systemMode = "시스템 설정과 동일"
        case lightMode = "밝은 모드"
        case darkMode = "어두운 모드"
    }

    @Environment(\.colorScheme) var colorScheme
   
    @State private var selectedMode: DisplayMode = .systemMode
    
    var body: some View {
        VStack {
            ForEach(DisplayMode.allCases, id: \.self) { label in
                TKListCell(label: label.rawValue) {
                } trailingUI: {
                    switch selectedMode {
                    case .systemMode, .lightMode, .darkMode:
                        if selectedMode == label {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 21))
                                .onTapGesture {
                                    selectedMode = label
                                }
                        } else {
                            Image(systemName: "circlebadge")
                                .font(.system(size: 26.8))
                                .onTapGesture {
                                    selectedMode = label
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .toolbar {
            ToolbarItem(placement: .principal) {
                BDText(text: "화면 모드", style: .H1_B_130)
            }
        }
    }
    
    // TODO: - 지금은 작동이 안됨. 나중에 작업.
    private func switchDisplayMode() -> ColorScheme {
        switch selectedMode {
        case .lightMode:
            return ColorScheme.light
        case .darkMode:
            return ColorScheme.dark
        default:
            return ColorScheme.light
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
