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
    @Environment(\.openURL) var openURL
    
    @State private var showEmail: Bool = false
    @State private var email: SupportEmail = SupportEmail(
        toAddress: "allway.team01a@gmail.com",
        subject: "[TALKLAT] 오류신고/문의하기",
        messageHeader: "[필수1] iPhone 기종 \n- \n[필수2] iOS 버전 \n- \n[필수3] 문의 내용 \n-"
    )
    
    var body: some View {
        VStack {
            TKListCell(label: "문의 및 오류 신고하기") {
            } trailingUI: {
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                email.send(openURL: openURL)
            }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEmail) {
            MailView(supportEmail: $email) { result in
                switch result {
                case .success:
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SettingsHelpView()
}
