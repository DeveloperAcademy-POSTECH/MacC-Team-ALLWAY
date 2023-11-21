//
//  SettingsDisplayView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI
struct SettingsDisplayView: View {
    @Environment(\.colorScheme) var current
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
    
    @State private var selectedTheme: ColorScheme = .dark
    
    @AppStorage("BDColorScheme") var BDColorScheme = ColorScheme.unspecified
    
    var body: some View {
        VStack {
            TKListCell(label: "시스템과 동일") {
            } trailingUI: {
                if selectedTheme == ColorScheme.unspecified {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = ColorScheme.unspecified
                colorSchemeManager.colorScheme = selectedTheme
            }
            
            TKListCell(label: "밝은 모드") {
            } trailingUI: {
                if selectedTheme == ColorScheme.light {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = ColorScheme.light
                colorSchemeManager.colorScheme = selectedTheme
            }
            
            TKListCell(label:"어두운 모드") {
            } trailingUI: {
                if selectedTheme == ColorScheme.dark {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 21))
                } else {
                    Image(systemName: "circlebadge")
                        .font(.system(size: 26.8))
                }
            }
            .onTapGesture {
                selectedTheme = ColorScheme.dark
                colorSchemeManager.colorScheme = selectedTheme
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .navigationTitle("화면 모드")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedTheme = colorSchemeManager.colorScheme
            
            print("---> BDColorScheme: ", BDColorScheme)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDisplayView()
    }
}
