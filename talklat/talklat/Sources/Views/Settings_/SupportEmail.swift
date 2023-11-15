//
//  SupportEmail.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI
import UIKit

struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var data: Data?
    var body: String {"""
        \(messageHeader)
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """
                )
            }
        }
    }
    
}
