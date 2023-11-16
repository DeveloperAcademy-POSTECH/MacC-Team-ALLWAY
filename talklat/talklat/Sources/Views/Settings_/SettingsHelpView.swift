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
    
    @State private var isEmailShowing: Bool = false
    @State private var emailResult: Result<MFMailComposeResult, Error>?
    
    var body: some View {
        VStack {
            TKListCell(label: "문의 및 오류 신고하기") {
            } trailingUI: {
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                isEmailShowing = true
            }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
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
