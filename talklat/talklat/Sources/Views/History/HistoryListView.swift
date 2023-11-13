//
//  HistoryListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    @State private var selectedConversationID: String = ""
    @State private var isEditing: Bool = false
    @State private var isDialogShowing: Bool = false
    @State internal var isSearching: Bool = false
    @State internal var searchText: String = ""
    
    private var sampleConversations: [TKConversationSample] {
        [
            // TKConversation 1
            TKConversationSample(
                id: UUID().uuidString,
                content: [
                    TKConversationSample.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 이거 혹시 새 제품 있나요?",
                        status: "question",
                        createdAt: Date.now
                    ),
                    TKConversationSample.TKContent(
                        id: UUID().uuidString,
                        text: "계속 찾고 있었는데 안보여요",
                        status: "question",
                        createdAt: Date.now
                    )
                ],
                location: TKConversationSample.TKLocation(
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
            TKConversationSample(
                id: UUID().uuidString,
                content: [
                    TKConversationSample.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 혹시 라네즈 쿠션 리필을 따로 판매하시나요?",
                        status: "question",
                        createdAt: Date.now
                    ),
                    TKConversationSample.TKContent(
                        id: UUID().uuidString,
                        text: "어 잠시만요",
                        status: "answer",
                        createdAt:  Date.now
                    )
                ],
                location: TKConversationSample.TKLocation(
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
            TKConversationSample(
                id: UUID().uuidString,
                content: [
                    TKConversationSample.TKContent(
                        id: UUID().uuidString,
                        text: "안녕하세요 오늘 5시 예약한 00인데요, 제가 귀가 안좋아서, 말씀하실 때 핸드폰에 대고 말씀해주시면 텍스트로 읽어보겠습니다.",
                        status: "question",
                        createdAt:  Date.now
                    )
                ],
                location: TKConversationSample.TKLocation(
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
    
    // not in store
    @FocusState internal var isSearchFocused: Bool
   
    var body: some View {
        VStack {
            // Search Bar
            SearchBarView(
                isSearching: $isSearching,
                searchText: $searchText
            )
            .focused($isSearchFocused)
            // .disabled(isEditing ? true : false)
            
            Spacer()
            
            // MARK: - History List
            if !isSearching {
                ScrollView {
                    // Unavailable View
                    if sampleConversations.isEmpty {
                        TKUnavailableViewBuilder(
                            icon: "bubble.left.and.bubble.right.fill",
                            description: "아직 대화 기록이 없어요"
                        )
                    } else {
                        ForEach(0 ..< 4) { _ in // TODO: all [TKLocation]
                            LocationList(
                                samples: sampleConversations,
                                selectedConversationID: $selectedConversationID,
                                isEditing: $isEditing,
                                isDialogShowing: $isDialogShowing
                            )
                        }
                        .padding(.top, 24)
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("히스토리")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        // Edit Button
                        ZStack {
                            Button {
                                withAnimation(
                                    .spring(
                                        dampingFraction: 0.7,
                                        blendDuration: 0.4
                                    )
                                ) {
                                    withAnimation {
                                        isEditing.toggle()
                                    }
                                }
                            } label: {
                                Text("편집")
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            } else {
                // MARK: - History Search
                HistoryListSearchView(
                    sampleConversations: sampleConversations,
                    isSearching: $isSearching,
                    searchText: $searchText
                )
            }
        }
        .padding(.horizontal, 20)
        .overlay {
            if isDialogShowing {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                CustomDialog(
                    selectedConversationID: $selectedConversationID,
                    isDialogShowing: $isDialogShowing,
                    isEditing: $isEditing
                )
            }
        }
        .onChange(of: isSearchFocused) { _, _ in
            withAnimation(
                .spring(
                    dampingFraction: 0.8,
                    blendDuration: 0.4
                )
            ) {
                if $isSearchFocused.wrappedValue {
                    isSearching = true
                } else {
                    isSearching = false
                }
            }
        }
        .onChange(of: isSearching) { _, _ in
            if !isSearching {
                isSearchFocused = false
            }
        }
    }
}

// MARK: - Location Based List Items
struct LocationList: View {
    internal var samples: [TKConversationSample]
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
                            blendDuration: 0.4
                        )
                    ) {
                        isCollapsed.toggle()
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
                    }
                }
                .disabled(isEditing)
            }
            
            // Each List Cell
            if !isCollapsed {
                ForEach(samples, id: \.self) { conversation in // TODO: each TKLocation의 TKConversation
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
    var conversation: TKConversationSample
    @State internal var isRemoving: Bool = false
    @Binding internal var selectedConversationID: String
    @Binding internal var isEditing: Bool
    @Binding internal var isDialogShowing: Bool
    
    var body: some View {
        HStack {
            HStack {
                // Leading Remove Button Appear
                if isEditing {
                    Button {
                        withAnimation(
                            .spring(
                                .bouncy,
                                blendDuration: 0.4
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
                                    .push(from: .trailing)
                                    .combined(with: .opacity)
                                )
                        }
                    }
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .push(from: .trailing)
                        )
                        .combined(with: .identity)
                    )
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(conversation.title) // TODO: TKConversation.title
                        .font(.system(size: 17, weight: .medium))
                    Text(
                        conversation.createdAt.formatted( // TODO: TKConversation.createdAt
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
            .onTapGesture {
                if isRemoving {
                    withAnimation(
                        .spring(
                            dampingFraction: 0.7,
                            blendDuration: 0.4
                        )
                    ) {
                        isRemoving = false
                    }
                }
            }

            // TrashBin Appear
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
            withAnimation {
                isRemoving = false
            }
        }
    }
}

// TODO: 히스토리뷰 스토어 생성 후 TKDialogBuilder로 분리
/// enum case .destruction (빨간색), .cancel (주황색) 필요
struct CustomDialog: View {
    @Binding internal var selectedConversationID: String
    @Binding internal var isDialogShowing: Bool
    @Binding internal var isEditing: Bool
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
                
                Text("대화 삭제")
                    .foregroundColor(.gray900)
                    .font(.system(size: 17, weight: .bold))
                
                Text("..에서 저장된\n모든 데이터가 삭제됩니다.") // TODO: TKConversation.title
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
                            .cornerRadius(16)
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
                            .cornerRadius(16)
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

#Preview {
    NavigationStack {
        HistoryListView()
    }
}


