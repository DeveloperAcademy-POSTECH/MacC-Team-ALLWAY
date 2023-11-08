//
//  HistoryListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    //    @Environment(\.modelContext) var context
    //    @Query private var conversations: [TKConversation]
    
    @State var isCollapsed: Bool = false
    
    private var sampleConversations: [TKConversation] {
        [
            // TKConversation 1
            TKConversation(
                id: UUID().uuidString,
                content: [
                    TKConversation.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 이거 혹시 새 제품 있나요?",
                        status: "question",
                        createdAt: Date.now
                    ),
                    TKConversation.TKContent(
                        id: UUID().uuidString,
                        text: "계속 찾고 있었는데 안보여요",
                        status: "question",
                        createdAt: Date.now
                    )
                ],
                location: TKConversation.TKLocation(
                    id: UUID().uuidString,
                    latitude: 0.0,
                    longitude: 0.0,
                    blockName: "포항시 효자동"
                ),
                title: "메모 1",
                createdAt: Date.now,
                updatedAt: Date.now
            ),
            
            // TKConversation 2
            TKConversation(
                id: UUID().uuidString,
                content: [
                    TKConversation.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 혹시 라네즈 쿠션 리필을 따로 판매하시나요?",
                        status: "question",
                        createdAt: Date.now
                    ),
                    TKConversation.TKContent(
                        id: UUID().uuidString,
                        text: "어 잠시만요",
                        status: "answer",
                        createdAt:  Date.now
                    )
                ],
                location: TKConversation.TKLocation(
                    id: UUID().uuidString,
                    latitude: 3242.0,
                    longitude: 34.0,
                    blockName: "세종시 모모동"
                ),
                title: "대잠 올리브영",
                createdAt: Date.now,
                updatedAt: Date.now
            ),
            
            // TKConversation 3
            TKConversation(
                id: UUID().uuidString,
                content: [
                    TKConversation.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 오늘 5시 예약한 00인데요, 제가 귀가 안좋아서, 말씀하실 때 핸드폰에 대고 말씀해주시면 텍스트로 읽어보겠습니다.",
                        status: "question",
                        createdAt:  Date.now
                    )
                ],
                location: TKConversation.TKLocation(
                    id: UUID().uuidString,
                    latitude: 3242.0,
                    longitude: 34.0,
                    blockName: "세종시 모모동"
                ),
                title: "세종 철학관",
                createdAt:  Date.now,
                updatedAt:  Date.now
            )
        ]
    }
    
    @State private var searchText: String = ""
    @State private var isHistoryEmpty: Bool = false
    @State private var selectedConversationID: String = ""
    @State private var isEditing: Bool = false
    @State private var isDialogShowing: Bool = false
    
    var body: some View {
        ScrollView {
            if isHistoryEmpty {
                emptyViewBuilder()
            } else {
                ForEach(0..<4) { _ in // TODO: get all identical locations
                    LocationList(
                        samples: sampleConversations,
                        selectedConversationID: $selectedConversationID,
                        isEditing: $isEditing,
                        isDialogShowing: $isDialogShowing
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("히스토리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Edit Button
                Button {
                    withAnimation(
                        .spring(
                            dampingFraction: 0.7,
                            blendDuration: 0.3
                        )
                    ) {
                        isEditing.toggle()
                    }
                } label: {
                    Text("편집")
                        .foregroundColor(.accentColor)
                        .fontWeight(.medium)
                }
            }
        }
        .overlay {
            if isDialogShowing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                CustomDialog(
                    selectedConversationID: $selectedConversationID,
                    isDialogShowing: $isDialogShowing,
                    isEditing: $isEditing
                )
            }
        }
    }
}

// MARK: - Location Based List Items
struct LocationList: View {
    internal var samples: [TKConversation]
    @State internal var isCollapsed: Bool = false
    @Binding internal var selectedConversationID: String
    @Binding internal var isEditing: Bool
    @Binding internal var isDialogShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "location.fill")
                Text("서울특별시 송파동") // TODO: location.blockName
                    .foregroundColor(.gray800)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, -5)
                
                Spacer()
                
                // Collapse Button
                Button {
                    withAnimation(
                        .spring(
                            .bouncy,
                            blendDuration: 0.3
                        )
                    ) {
                        if !isEditing {
                            isCollapsed.toggle()
                        }
                    }
                } label: {
                    if isCollapsed {
                        Image(systemName: "chevron.forward")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                    } else {
                        Image(systemName: "chevron.down")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .opacity,
                                    removal: .identity
                                )
                            )
                            .disabled(isEditing)
                    }
                    
                }
            }
            
            // Each List Cell
            if !isCollapsed {
                ForEach(samples, id: \.self) { conversation in
                    CellItem(
                        conversation: conversation,
                        selectedConversationID: $selectedConversationID,
                        isEditing: $isEditing,
                        isDialogShowing: $isDialogShowing
                    )
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity,
                        removal: .identity
                    )
                )
            }
        }
    }
}

struct CellItem: View {
    var conversation: TKConversation
    @State internal var isRemoving: Bool = false
    @Binding internal var selectedConversationID: String
    @Binding internal var isEditing: Bool
    @Binding internal var isDialogShowing: Bool
    
    var body: some View {
        HStack {
            HStack {
                if isEditing {
                    // Remove Button
                    Button {
                        withAnimation(
                            .spring(
                                .bouncy,
                                blendDuration: 0.3
                            )
                        ) {
                            isRemoving.toggle()
                        }
                    } label: {
                        if !isRemoving {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                                .padding(.trailing, 5)
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity,
                                        removal: .identity
                                    )
                                )
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(conversation.title) // TODO: title
                        .font(.system(size: 17, weight: .medium))
                    Text(
                        conversation.createdAt.formatted( // TODO: createdAt
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                    .foregroundColor(.gray400)
                    .font(.system(size: 15, weight: .medium))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .opacity(isEditing ? 0 : 1)
                    .foregroundColor(.gray400)
                    .font(
                        .system(
                            size: 17,
                            weight: .bold,
                            design: .rounded
                        )
                    )
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray100)
            .cornerRadius(22)

            if isRemoving && isEditing {
                Button {
                    withAnimation {
                        isDialogShowing = true
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(.red)
                        .cornerRadius(22)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .onChange(of: isEditing) { _, _ in
            isRemoving = false
        }
        .onAppear {
            CustomDialog(
                selectedConversationID: $selectedConversationID,
                isDialogShowing: $isDialogShowing,
                isEditing: $isEditing
            )
        }
    }
}

struct CustomDialog: View {
    @Binding internal var selectedConversationID: String
    @Binding internal var isDialogShowing: Bool
    @Binding internal var isEditing: Bool
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                Text("대화 삭제")
                    .foregroundColor(.gray900)
                    .font(.system(size: 17, weight: .bold))
                Text("..에서 저장된\n모든 데이터가 삭제됩니다.") // TODO: conversation.title
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray600)
                    .font(.system(size: 15, weight: .medium))
                
                HStack {
                    Button {
                        isDialogShowing = false
                        isEditing = false
                    } label: {
                        Text("아니요, 취소할래요")
                            .foregroundColor(.gray600)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.gray200)
                            .cornerRadius(22)
                    }
                    
                    Button {
                        // Delete
                        removeConversation(selectedConversationID)
                        isDialogShowing = false
                        isEditing = false
                    } label: {
                        Text("네, 삭제할래요")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.red)
                            .cornerRadius(22)
                    }
                }
            }
        }
        .cornerRadius(22)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
    }
    
    func removeConversation(_ id: String) {
        // TODO: Delete하는 로직 (String -> PersistentIdentifier를 이용해 객체를 특정)
        
    }
}

// MARK: - Empty View
@ViewBuilder
func emptyViewBuilder() -> some View {
    VStack(spacing: 15) {
        Image(systemName: "bubble.left.and.bubble.right.fill")
            .resizable()
            .frame(width: 117, height: 97)
            .foregroundColor(.gray200)
        
        Text("아직 대화 기록이 없어요")
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.gray300)
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
    }
}


