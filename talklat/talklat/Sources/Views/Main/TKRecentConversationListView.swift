//
//  TKRecentConversationListView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKRecentConversationListView: View, FirebaseAnalyzable {
    @EnvironmentObject var locationStore: TKLocationStore
    @ObservedObject var conversationViewStore: TKConversationViewStore
    @ObservedObject var draggableListViewStore: TKDraggableListViewStore
    let swiftDataStore: TKSwiftDataStore = TKSwiftDataStore()
    let firebaseStore: any TKFirebaseStore = NearMeFirebaseStore()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    if locationStore(\.isAuthorized) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(.GR5)
                            .padding(.trailing, 7)
                    } else {
                        Image("none.talk.light")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 7)
                    }
                    
                    BDText(text: NSLocalizedString("내 주변 대화 목록", comment: ""), style: ._22T2_B)
                        .foregroundStyle(Color.GR7)
                }
                .foregroundStyle(Color.GR5)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 32)
            .padding(.bottom, 16)
            
            ScrollView {
                if locationStore(\.isAuthorized) {
                    if draggableListViewStore(\.conversations).count > 0 {
                        ForEach(draggableListViewStore(\.conversations), id: \.self) { conversation in
                            Button {
                                firebaseStore.userDidAction(.tapped(.nearMeItem), .nearMeType(conversation, Int(locationStore.calculateDistance(conversation.location) ?? -1.0)))
                                draggableListViewStore.onTapDraggableListItem(conversation)
                                conversationViewStore.reduce(\.previousConversation, into: conversation)
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        BDText(text: conversation.title, style: ._17H_B)
                                            .foregroundStyle(Color.GR8)
                                        
                                        BDText(text: locationStore.calculateDistance(conversation.location).toStringDistance(), style: ._13F_M)
                                            .foregroundStyle(Color.OR6)
                                    }
                                    
                                    HStack {
                                        // MARK: 추후에 update되면 updatedAt을 넣는것으로 변경
                                        BDText(text: conversation.updatedAt?.convertToDate() ?? conversation.createdAt.convertToDate(), style: ._13F_M)
                                            .foregroundStyle(Color.GR4)
                                        
                                        Spacer()
                                        
                                        Group {
                                            BDText(text: NSLocalizedString("대화하기", comment: ""), style: ._15H2_SMB)
                                                .foregroundStyle(Color.GR7)
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        .font(.footnote)
                                        .foregroundStyle(Color.GR7)
                                    }
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.GR1)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        //                    .padding(.bottom, 32)
                    } else {
                        BDText(text: NSLocalizedString("근처에서 나눈 대화가 없어요.", comment: ""), style: ._15H2_SMB)
                            .foregroundStyle(Color.GR3)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.bottom, 32)
                            .padding(.horizontal, 32)
                    }
                } else {
                    BDText(text: NSLocalizedString("근처 대화 목록을 불러올 수 없습니다. 설정에서 위치 권한을 허용해주세요.", comment: ""), style: ._15H2_SMB)
                        .foregroundStyle(Color.GR3)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.bottom, 32)
                        .padding(.horizontal, 32)
                }
            }
            .refreshable {
                if locationStore.detectAuthorization() {
                    locationStore.trackUserCoordinate()
                    draggableListViewStore.reduce(
                        \.conversations,
                         into: locationStore.getClosestConversation(swiftDataStore.conversations)
                    )
                }
            }
        }
        .fullScreenCover(isPresented: draggableListViewStore.bindingIsShowingConversationView()) {
            TKConversationView(store: conversationViewStore)
                .onChange(of: conversationViewStore(\.isConversationFullScreenDismissed)) { old, new in
                    if !old, new {
                        draggableListViewStore.onConversationFullScreenDismissed()
                    }
                }
                .showTKAlert(
                    isPresented: conversationViewStore.bindingTKAlertFlag(),
                    style: .conversationCancellation
                ) {
                    draggableListViewStore.onConversationFullScreenDismissed()
                    
                } confirmButtonLabel: {
                    Text(NSLocalizedString("네, 그만 할래요", comment: ""))
                }
                .onDisappear {
                    conversationViewStore.resetConversationState()
                }
        }
    }
}

#Preview {
    TKRecentConversationListView(
        conversationViewStore: .init(),
        draggableListViewStore: .init()
    )
    .environmentObject(TKLocationStore())
}
