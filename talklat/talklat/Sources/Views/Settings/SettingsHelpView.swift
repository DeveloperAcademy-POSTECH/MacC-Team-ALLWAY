//
//  SettingsHelpView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import MessageUI
import SwiftUI
import UIKit


struct SettingsHelpView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    

    @State private var isEmailShowing: Bool = false
    @State private var emailResult: Result<MFMailComposeResult, Error>?
    
    let firebaseStore: any TKFirebaseStore = SettingsHelpsFirebaseStore()
    
    var body: some View {
        VStack {
            Button {
                openMail(
                    emailTo: "allway.team01@gmail.com",
                    subject: NSLocalizedString("mail.subject", comment: ""),
                    body: NSLocalizedString("mail.content", comment: "")
                )
            } label: {
                BDListCell(label: NSLocalizedString("inquiry.bugReport", comment: "")) {
                } trailingUI: {
                    Image(systemName: "chevron.right")
                }
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
                        
                        BDText(
                            text: NSLocalizedString("설정", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    .tint(Color.OR5)
                }
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: NSLocalizedString("needHelp.title", comment: ""),
                    style: .H1_B_130
                )
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .background(Color.ExceptionWhiteW8)
    }
    
    private func openMail(
        emailTo:String,
        subject: String,
        body: String
    ) {
        if let url = URL(
            string: "mailto:\(emailTo)?subject=\(subject)&body=\(body)"
        ),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        }
    }
}

#Preview {
    SettingsHelpView()
}
