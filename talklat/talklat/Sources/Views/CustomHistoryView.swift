//
//  CustomHistoryView.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation
import SwiftUI

struct CustomHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showWebSheet: Bool = false
    @State private var webURL: URL?
    let swipeDetectNotification = Notification.Name("swipeDetected")
    let webViewNotification = Notification.Name("webViewNotification")
    let historyViewType: HistoryViewType
    var conversation: TKConversation
    
    var body: some View {
        VStack {
            CustomHistoryViewControllerRepresentable(conversation: conversation)
                .onReceive(NotificationCenter.default.publisher(for: swipeDetectNotification)) { _ in
                    //MARK: swipe down action
                    
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
            
            
            switch historyViewType {
            case .preview:
                Button {
                    //MARK: Swipe down action
                } label: {
                    VStack {
                        Text("작성화면으로 돌아가기")
                            .font(.footnote)
                        Image(systemName: "chevron.down")
                            .resizable()
                            .frame(width: 32, height: 10)
                    }
                }
                .frame(maxWidth: .infinity)
            case .item:
                Button {
                    
                } label: {
                    Text("이 위치에서 대화 시작하기")
                        .foregroundStyle(Color.OR5)
                        .font(.headline)
                        .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray100)
                        .frame(maxWidth: .infinity)
                }

            }
        }
        .padding()
        .toolbar {
            if historyViewType == .item {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HistoryInfoItemView()
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(Color.OR5)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("목록")
                        }
                    }
                }
            }
        }
        .navigationTitle(historyViewType == .item ? conversation.title : "대화 내용")
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: SwipeDown 했을때의 액션 -> ConversationViewStore 연결
    func swipeDownAction() {

    }
}

#Preview {
    CustomHistoryView(historyViewType: .item, conversation: TKConversation(title: "title", createdAt: Date.now, content: [TKContent]()))
}
