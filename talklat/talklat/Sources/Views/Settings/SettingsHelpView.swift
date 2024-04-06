//
//  SettingsHelpView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import UIKit
import SwiftUI

struct SettingsHelpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button {
                openMail(
                    emailTo: "allway.team01@gmail.com",
                    subject: "[BISDAM] 오류신고/문의하기",
                    body: "[필수1] iPhone 기종 \n - \n [필수2] iOS 버전 \n - \n [필수3] 문의 내용 \n - "
                )
            } label: {
                BDListCell(label: "문의 및 오류 신고하기") {
                } trailingUI: {
                    Image(systemName: "chevron.right")
                }
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
    }
    
    private func openMail(
        emailTo:String,
        subject: String,
        body: String
    ) {
        if let url = URL(
            string: "mailto:\(emailTo)?subject=\(subject.fixToBrowserString())&body=\(body.fixToBrowserString())"
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
