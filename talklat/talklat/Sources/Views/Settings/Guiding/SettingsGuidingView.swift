//
//  SettingsGuidingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isGuidingEnabled: Bool = true
    
    var body: some View {
        VStack {
            BDListCell(label: NSLocalizedString("settings.guide.toggleLabel", comment: "")) {
                } trailingUI: {
                    Toggle(
                        "",
                        isOn: $isGuidingEnabled
                    )
                    .frame(width: 70)
                }
            
            BDText(
                text: NSLocalizedString("settings.guide.description", comment: ""),
                style: .H2_SB_135
            )
            .foregroundColor(.GR3)
            .padding(.bottom, 24)
            .padding(.top, 3)
            
            NavigationLink {
                SettingsGuidingEditView()
                    .navigationBarBackButtonHidden()
                
            } label: {
                BDListCell(label: NSLocalizedString("settings.guiding.edit", comment: "")) {
                    } trailingUI: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(
                                isGuidingEnabled
                                ? .OR6
                                : .GR4
                            )
                    }
            }
            .disabled(isGuidingEnabled ? false : true)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
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
                BDText(text: NSLocalizedString("settings.guiding.title", comment: ""), style: .H1_B_130)
            }
        }
        .background(Color.ExceptionWhiteW8)
        .onAppear {
            if isKeyPresentInUserDefaults(key: "isGuidingEnabled") {
                isGuidingEnabled = UserDefaults.standard.bool(forKey: "isGuidingEnabled")
            } else {
                isGuidingEnabled = true
            }
        }
        .onChange(of: isGuidingEnabled) { _, _ in
            UserDefaults.standard.setValue(
                isGuidingEnabled, 
                forKey: "isGuidingEnabled"
            )
        }
    }
}

public func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

#Preview {
    NavigationStack {
        SettingsGuidingView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

//isGuidingEnabled = UserDefaults.standard.bool(forKey: "isGuidingEnabled")
//print("ONAPPEAR", isGuidingEnabled)
//
//// intital Entrance for UserDefaults
//if !isNotFirstEntered {
//    isGuidingEnabled = true
//    
//    isNotFirstEntered = true
//    // Save isNotFirstEntered
//    UserDefaults.standard.set(
//        self.isNotFirstEntered,
//        forKey: "isNotFirstEntered"
//    )
//}
 
//
//print(
//    "Changed",
//    UserDefaults.standard.bool(
//        forKey: "isGuidingEnabled"
//    )
//)
