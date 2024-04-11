//
//  CustomHistoryView.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import Foundation
import SwiftUI

struct CustomHistoryView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @State private var showWebSheet: Bool = false
    @State private var webURL: URL?
    let swipeDetectNotification = Notification.Name("swipeDetected")
    let webViewNotification = Notification.Name("webViewNotification")
    let historyViewType: HistoryViewType
    var conversation: TKConversation
    
    let firebaseStore: any TKFirebaseStore = HistoryInfoFirebaseStore()
    
    var body: some View {
        VStack(spacing: 0) {
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
                        BDText(text: "작성화면으로 돌아가기", style: .FN_SB_135)
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .frame(width: 32, height: 10)
                    }
                }
                .frame(maxWidth: .infinity)
            
            case .item:
                // TODO: ver 1.1
                EmptyView()
//                Button {
//                    // MARK: Start Conversation From This Location
//                } label: {
//                    Text("이 위치에서 대화 시작하기")
//                        .foregroundStyle(Color.OR6)
//                        .font(.headline)
//                        .padding()
//                }
//                .frame(maxWidth: .infinity)
//                .background {
//                    RoundedRectangle(cornerRadius: 22)
//                        .fill(Color.GR1)
//                        
//                }
//                .padding(.horizontal, 10)
            }
        }
        .toolbar {
            if historyViewType == .item {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "back",
//                            nil
//                        )
                        firebaseStore.userDidAction(.tapped(.back))
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                            
                            BDText(
                                text: "목록",
                                style: .H1_B_130
                            )
                        }
                    }
                }
                
                // Navigation Title
                ToolbarItem(placement: .principal) {
                    BDText(
                        text: historyViewType == .item
                        ? conversation.title
                        : "대화 내용",
                        style: .H1_B_130
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HistoryInfoItemView(conversation: conversation)
                        
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(Color.OR5)
                }
            }
        }
        .fontWeight(.bold)
        .navigationTitle(historyViewType == .item ? conversation.title : "대화 내용")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
    }
    
    //MARK: SwipeDown 했을때의 액션 -> ConversationViewStore 연결
    func swipeDownAction() {

    }
}

#Preview {
    CustomHistoryView(
        historyViewType: .item,
        conversation: TKConversation(
            title: "title",
            createdAt: Date.now,
            content: [
                TKContent(text: "bb", type: .answer, createdAt: .now),
            ]
        )
    )
}
