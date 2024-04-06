//
//  SettingsHelpView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI
import UIKit
import MessageUI

struct SettingsHelpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEmailShowing: Bool = false
    @State private var emailResult: Result<MFMailComposeResult, Error>?
    
    var body: some View {
        VStack {
            BDListCell(label: NSLocalizedString("inquiry.bugReport", comment: "")) {
            } trailingUI: {
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                isEmailShowing = true
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
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
