//
//  DataTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/11/23.
//

import SwiftUI
import SwiftData

struct CreateConversationView: View {
    var dataStore: TKSwiftDataStore = TKSwiftDataStore()
    
    // TKConversation
    @State private var title: String = "Talklat"
    @State private var createdAt: Date = Date()
    // TKContent
    @State private var text: String = ""
    @State private var status: MessageType.RawValue = "answer"
    @State private var contentCreatedAt: Date = Date()
    
    var body: some View {
        VStack {
            TextField("conversation title", text: $title)
                .textFieldStyle(.roundedBorder)
            
            TextEditor(text: $text)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5))
                    
                    if text == "" {
                        Text("content text")
                            .foregroundColor(Color(.systemGray3))
                    }
                }
            
            Picker("content status", selection: $status) {
                Text("question").tag("question")
                Text("answer").tag("answer")
            }
            
            // Submit
            Button("Create Conversation") {
                addConversation()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink("Switch to List View") {
                ConversationListView(dataManager: dataStore)
            }
            .padding(.vertical, 40)
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 20)
        .frame(height: 500)
    }
    
    // TODO: - 실제 뷰에선 해당 메서드 전부 Store로 이동
    private func addConversation() {
        withAnimation {
            let content = [TKContent(
                text: text,
                status: status,
                createdAt: Date()
            )]
            
            // 임시 자동생성
            let location = TKLocation(
                latitude: 0.2,
                longitude: 3.1,
                blockName: "상도동"
            )
            
            let conversation = TKConversation(
                title: title,
                createdAt: Date(),
                content: content,
                location: location
            )
            
            dataStore.appendItem(conversation)
        }
    }
}

struct ConversationListView: View {
    var dataManager: TKSwiftDataStore
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(dataManager.conversations) { conversation in
                    // ForEach(dataManager.locations) { location in
                    
                    ItemCell(
                        dataManager: dataManager,
                        conversation: conversation
                    )
                    .padding(.horizontal, 20)
                    
                    /*
                     ItemCell(
                     dataManager: dataManager,
                     location: location
                     )
                     .padding(.horizontal, 20)
                     */
                }
            }
            
            NavigationLink("Switch to Create View") {
                CreateConversationView()
            }
            .padding(.vertical, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ItemCell: View {
    var dataManager: TKSwiftDataStore
    var conversation: TKConversation
    // var location: TKLocation
    
    @State private var newTitle: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(conversation.title)
            // Text(location.blockName)
                .fontWeight(.bold)
            
            Divider()
            
            Button("delete") {
                dataManager.removeItem(conversation)
                // dataManager.removeItem(location)
            }
            
            Divider()
            
            HStack {
                TextField("new title", text: $newTitle)
                    .textFieldStyle(.roundedBorder)
                
                Button("update Title") {
                    conversation.title = newTitle
                }
            }
        }
        .padding()
        .background(.yellow.opacity(0.2))
        .cornerRadius(20)
    }
}

//#Preview {
//    ConversationListView()
//}

