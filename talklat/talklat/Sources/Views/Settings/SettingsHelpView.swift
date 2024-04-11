//
//  SettingsHelpView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI
import UIKit
import MessageUI

struct SettingsHelpView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEmailShowing: Bool = false
    @State private var emailResult: Result<MFMailComposeResult, Error>?
    
    let firebaseStore: any TKFirebaseStore = SettingsHelpsFirebaseStore()
    
    var body: some View {
        VStack {
            BDListCell(label: "문의 및 오류 신고하기") {
            } trailingUI: {
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                firebaseStore.userDidAction(.tapped(.mail))
                isEmailShowing = true
            }
            
            Spacer()
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    firebaseStore.userDidAction(.tapped(.back))
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(text: "설정", style: .H1_B_130)
                    }
                    .tint(Color.OR5)
                }
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: "도움이 필요하신가요?",
                    style: .H1_B_130
                )
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .sheet(isPresented: $isEmailShowing) {
            EmailView(
                isShowing: $isEmailShowing,
                result: $emailResult
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsHelpView()
}
