//
//  TKSavingView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftData
import SwiftUI

struct TKSavingView: View, FirebaseAnalyzable {
    // MARK: - TKLocation Manager, TKConversation Manager Here
    @Environment(\.dismiss) private var dismiss
    @Environment(TKSwiftDataStore.self) private var swiftDataStore
    @EnvironmentObject var locationStore: TKLocationStore
    
    @ObservedObject var store: TKConversationViewStore
    @FocusState var focusState: Bool
    @State private var allConversationTitles: [String] = []
    let firebaseStore: any TKFirebaseStore = ConversationSaveFirebaseStore()
    var speechRecognizeManager: SpeechRecognizer
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack {
                Button {
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "cancel",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.cancel))
                    store.onDismissSavingViewButtonTapped()
                    
                } label: {
                    BDText(
                        text: "취소",
                        style: .H1_B_130
                    )
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                    
                    BDText(text: locationStore(\.mainPlaceName), style: .H1_B_130)
                }
                .foregroundStyle(Color.GR7)
                
                Spacer()
                
                Button {
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "save",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.save))
                    if let res: TKConversation = store.makeNewConversation(
                        with: speechRecognizeManager.currentTranscript,
                        at: TKLocation(
                            latitude: locationStore(\.currentUserCoordinate?.center.latitude) ?? initialLatitude,
                            longitude: locationStore(\.currentUserCoordinate?.center.longitude) ?? initialLongitude,
                            blockName: locationStore(\.mainPlaceName)
                        )
                    ) {
                        swiftDataStore.appendItem(res)
                        store.onSaveNewConversationButtonTapped()
                    }
                    
                } label: {
                    BDText(
                        text: "저장",
                        style: .H1_B_130
                    )
                }
                .disabled(store(\.conversationTitle).isEmpty)
            }
            .font(.headline)
            .bold()
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            HStack {
                BDText(text: "제목", style: .H2_SB_135)
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
                .focused($focusState)
                .onChange(of: focusState) { _, newValue in
                    if newValue == true {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "field",
//                            nil)
                        firebaseStore.userDidAction(.tapped(.field))
                    }
                }
                
                Spacer()
                
                Button {
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "eraseAll",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.eraseAll))
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
                BDText(text: "한 글자 이상 입력해 주세요", style: .FN_SB_135)
                    .foregroundStyle(Color.RED)
                    .padding(.leading, 32)
                    .transition(.opacity.animation(.easeInOut))
                
            } else if store(\.hasCurrentConversationTitlePrevious) {
                Text("이미 있는 제목이에요")
                    .font(.footnote)
                    .foregroundStyle(Color.RED)
                    .padding(.leading, 32)
                
            } else {
                BDText(text: "\(store(\.conversationTitle).count)/\(store.conversationTitleLimit)", style: .FN_SB_135)
                    .padding(.leading, 32)
                    .foregroundStyle(Color.GR4)
                    .animation(.none, value: store(\.conversationTitle))
            }
        }
        .task {
            if !swiftDataStore.conversations.isEmpty {
                let allConversations = swiftDataStore.getAllConversation()
                store.onSaveConversationSheetAppear(allConversations)
            }
            
            focusState = true
            firebaseStore.userDidAction(.viewed)
        }
        .animation(.easeInOut, value: store(\.conversationTitle))
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 26)
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
