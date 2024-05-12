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
            BDListCell(label: "대화 시작 시 안내 문구 사용") {
                } trailingUI: {
                    Toggle(
                        "",
                        isOn: $isGuidingEnabled
                    )
                    .frame(width: 70)
                }
            
            BDText(
                text: "안내 문구는 상대방에게 대화 시작 시 필요한 안내 사항을 보여주는 용도로 사용할 수 있어요.",
                style: .H2_SB_135
            )
            .foregroundColor(.GR3)
            .padding(.bottom, 24)
            .padding(.top, 3)
            
            NavigationLink {
                SettingsGuidingEditView()
                    .navigationBarBackButtonHidden()
                
            } label: {
                BDListCell(label: "안내 문구 편집") {
                    } trailingUI: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(
                                isGuidingEnabled
                                ? .OR6
                                : .GR4
                            )
                    }
            }
            .opacity(isGuidingEnabled ? 1.0 : 0.3)
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
                            text: "설정",
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: "안내 문구", style: .H1_B_130)
            }
        }
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
