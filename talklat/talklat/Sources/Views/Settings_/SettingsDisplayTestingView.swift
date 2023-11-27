//
//  SettingsDisplayTestingView.swift
//  bisdam
//
//  Created by Ye Eun Choi on 11/21/23.
//

import SwiftUI

struct SettingsDisplayTestingView: View {
    @Environment(\.colorScheme) var current
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager
   
    static var BDColorScheme: ColorScheme {
        get {
            return UserDefaults.standard.object(
                forKey: "BDColorScheme"
            ) as? ColorScheme ?? .unspecified
        }
        set {
            UserDefaults.standard.set(
                newValue.rawValue,
                forKey: "BDColorScheme"
            )
            UserDefaults.standard.synchronize()
        }
    }
    
    var body: some View {
        VStack {
            Text("TestingView..")
        }
        .onAppear {
            print("----> BDColorScheme: ", SettingsDisplayTestingView.BDColorScheme)
        }
    }
}

#Preview {
    SettingsDisplayTestingView()
}
