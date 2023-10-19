//
//  TKColor.swift
//  talklat
//
//  Created by Celan on 2023/10/18.
//

import SwiftUI

extension Color {
    static var colorScheme = UITraitCollection.current.userInterfaceStyle

    static var gray100: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#F7F7FA")
            case .dark:
                return Color(hex: "#1C1D27")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray200: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#EBEBF3")
            case .dark:
                return Color(hex: "#323340")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray300: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#D6D6E1")
            case .dark:
                return Color(hex: "#4B4E5B")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray400: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#B1B2BE")
            case .dark:
                return Color(hex: "#676A77")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray500: Color {
        get { Color(hex: "#868896") }
    }
    
    static var gray600: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#676A77")
            case .dark:
                return Color(hex: "#B1B2BE")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray700: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#4B4E5B")
            case .dark:
                return Color(hex: "#D6D6E1")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray800: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#393B49")
            case .dark:
                return Color(hex: "#EBEBF3")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
    
    static var gray900: Color {
        get {
            switch colorScheme {
            case .light:
                return Color(hex: "#222331")
            case .dark:
                return Color(hex: "#F7F7FA")
            case .unspecified:
                return Color.gray
            @unknown default:
                return Color.gray
            }
        }
    }
}

struct ColorTestView: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.gray100
                .overlay { Text("Color Gray 100") }
            Color.gray200
                .overlay { Text("Color Gray 200") }
            Color.gray300
                .overlay { Text("Color Gray 300") }
            Color.gray400
                .overlay { Text("Color Gray 400") }
            Color.gray500
                .overlay { Text("Color Gray 500") }
            Color.gray600
                .overlay { Text("Color Gray 600") }
            Color.gray700
                .overlay { Text("Color Gray 700") }
            Color.gray800
                .overlay { Text("Color Gray 800") }
            Color.gray900
                .overlay { Text("Color Gray 900") }
        }
        .ignoresSafeArea(edges: .bottom)
        .background { Color.red }
    }
}
