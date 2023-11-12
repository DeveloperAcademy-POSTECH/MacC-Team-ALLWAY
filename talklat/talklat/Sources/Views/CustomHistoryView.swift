//
//  CustomHistoryView.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation
import SwiftUI

struct CustomHistoryView: View {
    let conversationViewStore: ConversationViewStore
    @State private var showWebSheet: Bool = false
    @State var webURL: URL?
    
    let swipeDetectNotification = Notification.Name("swipeDetected")
    let webViewNotification = Notification.Name("webViewNotification")
    
    var body: some View {
        VStack {
            VStack {
                CustomHistoryViewControllerRepresentable()
                Button {
                    conversationViewStore.reduce(\.conversationStatus, into: .writing)
                    conversationViewStore.reduce(\.isTopViewShown, into: false)
                } label: {
                    VStack {
                        Text("작성화면으로 돌아가기")
                            .font(.footnote)
                        Image(systemName: "chevron.down")
                            .resizable()    .frame(width: 32, height: 10)
                    }
                }
            }
            .padding()
        }
        .onReceive(NotificationCenter.default.publisher(for: swipeDetectNotification)) { _ in
            // swipe down action
            withAnimation {
                swipeDownAction()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: webViewNotification, object: nil)) { data in // web view sheet action
            
            if let url = data.object as? URL {
                webURL = url
                if webURL != nil {
                    webURL = webURL
                    showWebSheet = true
                }
            } else {
                print("cannot convert url")
            }
        }
        .sheet(isPresented: $showWebSheet) {
            SheetWebView(webURL: $webURL)
        }
    }
    
    func swipeDownAction() {
        conversationViewStore.reduce(\.conversationStatus, into: .writing)
        conversationViewStore.reduce(\.isTopViewShown, into: false)
    }
}

#Preview {
    CustomHistoryView(conversationViewStore: ConversationViewStore(conversationState: .init(conversationStatus: .writing)))
}
