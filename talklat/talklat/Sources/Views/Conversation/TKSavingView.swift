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
    @EnvironmentObject var locationStore: TKLocationStore
    @ObservedObject var store: TKConversationViewStore
    @ObservedObject var speechRecognizeManager: SpeechRecognizer
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
                
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                    
                    BDText(text: locationStore(\.mainPlaceName), style: .H1_B_130)
                }
                .foregroundStyle(Color.GR7)
                
                Spacer()
                
                Button {
                    let res = makeNewConversation()
                    swiftDataStore.appendItem(res)
                    store.onSaveNewConversationButtonTapped()
                    
                } label: {
                    Text("저장")
                }
                .disabled(store(\.historyItems).isEmpty || store(\.conversationTitle).isEmpty)
            }
            .font(.headline)
            .bold()
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            HStack {
                Text("제목")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.GR5)
                
                Spacer()

            }
            .padding(.horizontal, 32)
            .padding(.bottom, 8)
            
            HStack {
                TextField(
                    "대화 제목을 지어주세요",
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
                        .foregroundStyle(Color.GR4)
                }
                .padding(.trailing, 16)
            }
            .background {
                Capsule()
                    .fill(Color.GR1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            if store(\.conversationTitle).isEmpty {
                Text("한 글자 이상 입력해 주세요")
                    .font(.footnote)
                    .foregroundStyle(Color.RED)
                    .padding(.leading, 32)
                    .transition(.opacity.animation(.easeInOut))
                
            } else {
                Text("\(store(\.conversationTitle).count)/\(store.conversationTitleLimit)")
                    .font(.footnote)
                    .padding(.leading, 32)
                    .foregroundStyle(Color.GR4)
                    .animation(.none, value: store(\.conversationTitle))
            }
        }
        .task {
            let allConversations = swiftDataStore.getAllConversation()
            store.onSaveConversationSheetApeear(allConversations.count)
        }
        .animation(.easeInOut, value: store(\.conversationTitle))
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 26)
    }
    
    private func makeNewConversation() -> some PersistentModel {
        store.onSpeechTransicriptionUpdated(speechRecognizeManager.transcript)
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
                latitude: locationStore(\.currentUserCoordinate?.center.latitude) ?? initialLatitude ,
                longitude: locationStore(\.currentUserCoordinate?.center.longitude) ?? initialLongitude,
                blockName: locationStore(\.mainPlaceName)
        ))
        
        return newConversation
    }
}

#Preview {
    Color.black
        .sheet(
            isPresented: .constant(true)
        ) {
            TKSavingView(store: .init(), speechRecognizeManager: .init())
                .environmentObject(TKLocationStore())
        }
}
