//
//  TKSavingView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftData
import SwiftUI

struct TKSavingView: View {
    // MARK: - TKLocation Manager, TKConversation Manager Here
    @EnvironmentObject var locationStore: LocationStore
    @ObservedObject var store: TKConversationViewStore
    @Environment(\.dismiss) private var dismiss
    let swiftDataStore = TKSwiftDataStore()
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack {
                Button {
                    store.onDismissSavingViewButtonTapped()
                    
                } label: {
                    Text("취소")
                }
                
                Spacer()
                
                Text("새 대화 저장")
                
                Spacer()
                
                Button {
                    let res = makeNewConversation()
                    swiftDataStore.appendItem(res)
                    store.onSaveNewConversationButtonTapped()
                } label: {
                    Text("저장")
                }
            }
            .font(.headline)
            .bold()
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            Text("제목")
                .font(.headline)
                .padding(.leading, 32)
                .padding(.bottom, 8)
                .foregroundStyle(Color.GR5)
            
            HStack {
                TextField(
                    "Conversation Title",
                    text: store.bindingConversationTitle()
                )
                    .font(.headline)
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                
                Spacer()
                
                Button {
                    store.onDeleteConversationTitleButtonTapped()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 16)
            }
            .background {
                Capsule()
                    .fill(Color.GR1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            Text("\(store(\.conversationTitle).count)/\(store.conversationTitleLimit)")
                .font(.footnote)
                .padding(.leading, 32)
                .foregroundStyle(Color.GR4)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 26)
    }
    
    private func makeNewConversation() -> some PersistentModel {
        store.onMakeNewConversationData()
        
        let newContents = store(\.historyItems).map {
            TKContent(
                text: $0.text,
                type: $0.type == .answer ? .answer : .question,
                createdAt: $0.createdAt
            )
        }
        
        let newConversation = TKConversation(
            title: store(\.conversationTitle),
            createdAt: Date(),
            content: newContents,
            location: TKLocation(
                latitude: locationStore(\.currentUserCoordinate?.latitude) ?? initialLatitude ,
                longitude: locationStore(\.currentUserCoordinate?.longitude) ?? initialLongitude,
                blockName: locationStore(\.currentShortPlaceMark),
                mapThumbnail: nil
            )
        )
        
        return newConversation
    }
}

#Preview {
    Color.black
        .sheet(
            isPresented: .constant(true)
        ) {
            TKSavingView(store: .init())
        }
}
