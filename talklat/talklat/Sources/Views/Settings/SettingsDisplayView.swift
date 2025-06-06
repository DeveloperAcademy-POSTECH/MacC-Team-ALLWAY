//
//  SettingsDisplayView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI

private enum ColorSchemeType: String, CaseIterable {
    case device
    case light
    case dark
    
    var title: String {
        switch self {
        case .device: return NSLocalizedString("systemMode", comment: "")
        case .light: return NSLocalizedString("lightMode", comment: "")
        case .dark: return NSLocalizedString("darkMode", comment: "")
        }
    }
    
    var theme: ColorScheme {
        switch self {
        case .device: return ColorScheme.unspecified
        case .light: return ColorScheme.light
        case .dark: return ColorScheme.dark
        }
    }
}

struct SettingsDisplayView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("BDColorScheme") var BDColorScheme = ColorScheme.unspecified
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    @State private var selectedTheme: ColorScheme = .dark
    
    let firebaseStore: any TKFirebaseStore = SettingsDisplayModeFirebaseStore()
    
    var body: some View {
        VStack {
            ForEach(ColorSchemeType.allCases, id: \.self) { type in
                BDListCell(label: type.title) {
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
                    switch type {
                    case .device:
                        firebaseStore.userDidAction(.tapped(.sameMode))
                    case .light:
                        firebaseStore.userDidAction(.tapped(.lightMode))
                    case .dark:
                        firebaseStore.userDidAction(.tapped(.darkMode))
                    }
                    selectedTheme = type.theme
                    colorSchemeManager.colorScheme = selectedTheme
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    firebaseStore.userDidAction(.tapped(.back))
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: NSLocalizedString("설정", comment: ""),
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(
                    text: NSLocalizedString("displayMode.title", comment: ""),
                    style: .H1_B_130
                )
            }
        }
        .background(Color.ExceptionWhiteW8)
        .onAppear {
            firebaseStore.userDidAction(.viewed)
            selectedTheme = colorSchemeManager.colorScheme
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
