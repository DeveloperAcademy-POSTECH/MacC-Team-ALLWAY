//
//  TKColor.swift
//  talklat
//
//  Created by Celan on 2023/10/18.
//

import SwiftUI

extension Color {
    static let OR5 = Color("OR5")
    static let OR6 = Color("OR6")
   
    static let BaseBGWhite = Color("BaseBGWhite")
    static let SheetBGWhite = Color("SheetBGWhite")
    static let AlertBGWhite = Color("AlertBGWhite")
    
    static let RED = Color("RED")
    
    static let GR1 = Color("GR1")
    static let GR2 = Color("GR2")
    static let GR3 = Color("GR3")
    static let GR4 = Color("GR4")
    static let GR5 = Color("GR5")
    static let GR6 = Color("GR6")
    static let GR7 = Color("GR7")
    static let GR8 = Color("GR8")
    static let GR9 = Color("GR9")
}

//extension Color {
//    // BISDAM app's colorScheme
//    static var BDColorScheme: ColorScheme = .unspecified
//    
//    // system's colorScheme
//    static var systemColorScheme = UITraitCollection.current.userInterfaceStyle
//    
//    static var OR5: Color {
//        get { Color(hex: "FF6838") }
//    }
//    
//    static var OR6: Color {
//        get { Color(hex: "#F75927") }
//    }
//    
//    static var BaseBGWhite: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#000000")
//                case .unspecified:
//                    return .white
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#000000")
//                case .unspecified:
//                    return .white
//                @unknown default:
//                    return .white
//                }
//            }
//        }
//    }
//    
//    static var SheetBGWhite: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#272732")
//                case .unspecified:
//                    return .white
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#272732")
//                case .unspecified:
//                    return .white
//                @unknown default:
//                    return .white
//                }
//            }
//        }
//    }
//    
//    static var AlertBGWhite: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#3F3F49")
//                case .unspecified:
//                    return .white
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color.white
//                case .dark:
//                    return Color(hex: "#3F3F49")
//                case .unspecified:
//                    return .white
//                @unknown default:
//                    return .white
//                }
//            }
//        }
//    }
//    
//    static var RED: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#F75927")
//                case .dark:
//                    return Color(hex: "#FF0D2A")
//                case .unspecified:
//                    return .red
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#F75927")
//                case .dark:
//                    return Color(hex: "#FF0D2A")
//                case .unspecified:
//                    return .red
//                @unknown default:
//                    return .red
//                }
//            }
//        }
//    }
//    
//    static var GR1: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#F2F2F7")
//                case .dark:
//                    return Color(hex: "#1A1A24")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#F2F2F7")
//                case .dark:
//                    return Color(hex: "#1A1A24")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR2: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#E5E5EB")
//                case .dark:
//                    return Color(hex: "#272732")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#E5E5EB")
//                case .dark:
//                    return Color(hex: "#272732")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR3: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#C0C0C8")
//                case .dark:
//                    return Color(hex: "#3F3F49")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#C0C0C8")
//                case .dark:
//                    return Color(hex: "#3F3F49")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR4: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#9A9AA4")
//                case .dark:
//                    return Color(hex: "#575761")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#9A9AA4")
//                case .dark:
//                    return Color(hex: "#575761")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR5: Color {
//        get { Color(hex: "#75757F") }
//    }
//    
//    static var GR6: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#575761")
//                case .dark:
//                    return Color(hex: "#9A9AA4")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#575761")
//                case .dark:
//                    return Color(hex: "#9A9AA4")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR7: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#3F3F49")
//                case .dark:
//                    return Color(hex: "#C0C0C8")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#3F3F49")
//                case .dark:
//                    return Color(hex: "#C0C0C8")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR8: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#272732")
//                case .dark:
//                    return Color(hex: "#E5E5EB")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#272732")
//                case .dark:
//                    return Color(hex: "#E5E5EB")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//    
//    static var GR9: Color {
//        get {
//            if BDColorScheme != .unspecified {
//                switch BDColorScheme {
//                case .light:
//                    return Color(hex: "#1A1A24")
//                case .dark:
//                    return Color(hex: "#F2F2F7")
//                case .unspecified:
//                    return Color.gray
//                }
//            } else {
//                switch systemColorScheme {
//                case .light:
//                    return Color(hex: "#1A1A24")
//                case .dark:
//                    return Color(hex: "#F2F2F7")
//                case .unspecified:
//                    return Color.gray
//                @unknown default:
//                    return Color.gray
//                }
//            }
//        }
//    }
//}
//
//struct ColorTestView: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            Color.GR1
//                .overlay { Text("Color Gray 100") }
//            Color.GR2
//                .overlay { Text("Color Gray 200") }
//            Color.GR3
//                .overlay { Text("Color Gray 300") }
//            Color.GR4
//                .overlay { Text("Color Gray 400") }
//            Color.GR5
//                .overlay { Text("Color Gray 500") }
//            Color.GR6
//                .overlay { Text("Color Gray 600") }
//            Color.GR7
//                .overlay { Text("Color Gray 700") }
//            Color.GR8
//                .overlay { Text("Color Gray 800") }
//            Color.GR9
//                .overlay { Text("Color Gray 900") }
//        }
//        .ignoresSafeArea(edges: .bottom)
//        .background { Color.red }
//    }
//}
