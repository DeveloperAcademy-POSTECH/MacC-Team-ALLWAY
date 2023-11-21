//
//  MailView.swift
//  talklat

//  Created by kimsangwoo on 10/17/23.
//

import SwiftUI
import MessageUI

struct EmailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        
        viewController.setToRecipients(["allway.team01a@gmail.com"])
        
        viewController.setSubject("[BISDAM]오류신고/문의하기")
        
        let emailBody = "[필수1] iPhone 기종 \n - \n [필수2] iOS 버전 \n - \n [필수3] 문의 내용 \n - "
        viewController.setMessageBody(emailBody, isHTML: false)
        
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Configure the email compose view here if needed
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailView

        init(_ parent: EmailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            parent.isShowing = false
        }
    }
}
