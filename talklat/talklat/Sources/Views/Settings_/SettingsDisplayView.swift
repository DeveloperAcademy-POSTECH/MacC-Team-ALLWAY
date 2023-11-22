//
//  SettingsDisplayView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

internal enum Theme: String, CaseIterable {
  case device = "시스템 설정과 동일"
  case light = "밝은 모드"
  case dark = "어두운 모드"
}

struct SettingsDisplayView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTheme: Theme = .device
    
    var body: some View {
        VStack {
            TKListCell(label: Theme.device.rawValue) {
            } trailingUI: {
                if selectedTheme == .device {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = .device
                changeTheme(to: .device)
            }
            
            TKListCell(label: Theme.light.rawValue) {
            } trailingUI: {
                if selectedTheme == .light {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = .light
                changeTheme(to: .light)
            }
            
            TKListCell(label: Theme.dark.rawValue) {
            } trailingUI: {
                if selectedTheme == .dark {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = .dark
                changeTheme(to: .dark)
            }
            
            Spacer()
        }
        .onAppear {
            selectedTheme = UserDefaults.standard.theme
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .navigationTitle("화면 모드")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func changeTheme(to theme: Theme) {
        UserDefaults.standard.theme = theme
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle  = theme.userInterfaceStyle
    }
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .device:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension UserDefaults {
    var theme: Theme {
        get {
            register(defaults: [#function: Theme.device.rawValue])
            return Theme(
                rawValue: string(
                    forKey: #function
                ) ?? "시스템 설정과 동일"
            ) ?? .device
        }
        set {
            set(
                newValue.rawValue,
                forKey: #function
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
