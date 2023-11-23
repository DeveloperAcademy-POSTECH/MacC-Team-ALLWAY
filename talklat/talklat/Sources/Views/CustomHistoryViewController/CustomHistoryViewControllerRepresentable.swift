//
//  CustomHistoryView.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation
import SwiftUI

struct CustomHistoryViewControllerRepresentable: UIViewControllerRepresentable {
    var conversation: TKConversation
    func makeUIViewController(context: Context) -> some UIViewController {
        let historyViewController = HistoryViewController()
        historyViewController.conversation = conversation
        return historyViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // update ViewController
    }
}
