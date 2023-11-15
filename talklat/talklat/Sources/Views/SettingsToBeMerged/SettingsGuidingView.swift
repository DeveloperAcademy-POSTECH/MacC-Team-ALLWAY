//
//  SettingsGuidingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI

struct SettingsGuidingView: View {
    @State private var isNotFirstEntered: Bool = UserDefaults.standard.bool(
        forKey: "isFirstEntered"
    )
    
    @State private var isGuidingEnabled: Bool = UserDefaults.standard.bool(
        forKey: "isGuidingEnabled"
    )
   
    var body: some View {
        VStack {
            TKListCell(label: "대화 시작 시 안내 문구 사용") {
                } trailingUI: {
                    Toggle("", isOn: $isGuidingEnabled)
                        .frame(width: 70)
                }
            
            Text("안내 문구는 상대방에게 대화 시작 시 필요한 안내 사항을 보여주는 용도로 사용할 수 있어요.")
                .foregroundColor(.gray300)
                .font(.system(size: 15, weight: .semibold))
                .padding(.bottom, 24)
                .padding(.top, 3)
            
            NavigationLink {
                SettingsGuidingEditView()
            } label: {
                TKListCell(label: "안내 문구 편집") {
                    } trailingUI: {
                        Image(systemName: "chevron.right")
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .navigationTitle("안내 문구")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // intital Entrance for UserDefaults
            if !isNotFirstEntered {
                isGuidingEnabled = true
                
                // Save isGuidingEnabled
                UserDefaults.standard.set(
                    self.isGuidingEnabled,
                    forKey: "isGuidingEnabled"
                )
                
                isNotFirstEntered = true
                // Save isNotFirstEntered
                UserDefaults.standard.set(
                    self.isNotFirstEntered,
                    forKey: "isNotFirstEntered"
                )
            }
        }
        .onChange(of: isGuidingEnabled) { _, _ in
            // Save isGuidingEnabled
            UserDefaults.standard.set(
                self.isGuidingEnabled,
                forKey: "isGuidingEnabled"
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsGuidingView()
    }
}
