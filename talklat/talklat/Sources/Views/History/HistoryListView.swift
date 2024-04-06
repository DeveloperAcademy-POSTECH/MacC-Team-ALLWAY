//
//  HistoryListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TKSwiftDataStore.self) private var dataStore
    
    @State private var selectedConversation: TKConversation = TKConversation(
        title: "",
        createdAt: Date.now,
        content: [TKContent(
            text: "",
            type: .answer,
            createdAt: Date.now
        )]
    )
    @State private var isEditing: Bool = false
    @State private var isDialogShowing: Bool = false
    @State internal var isSearching: Bool = false
    @State internal var searchText: String = ""
    
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
            .navigationBarBackButtonHidden(true)
            .disabled(isEditing ? true : false)
            
            Spacer()
            
            // MARK: - History List
            if !isSearching {
                Group {
                    // Unavailable View
                    if dataStore.conversations.isEmpty {
                        TKUnavailableViewBuilder(
                            icon: "bubble.left.and.bubble.right.fill",
                            description: "아직 대화 기록이 없어요"
                        )
                    } else {
                        ScrollView {
                            ForEach(
                                dataStore.filterDuplicatedBlockNames(
                                    locations: dataStore.locations
                                )
                            ) { location in
                                LocationList(
                                    dataStore: dataStore,
                                    location: location,
                                    selectedConversation: $selectedConversation,
                                    isEditing: $isEditing,
                                    isDialogShowing: $isDialogShowing
                                )
                                .padding(.bottom, 24)
                            }
                            .padding(.top, 24)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        // Back Button
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .bold()
                                
                                BDText(
                                    text: NSLocalizedString("home.title", comment: ""),
                                    style: .H1_B_130
                                )
                            }
                            .fontWeight(.medium)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        BDText(
                            text: NSLocalizedString("히스토리", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        // Edit Button
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
                            BDText(
                                text: isEditing ? NSLocalizedString("완료", comment: "") : NSLocalizedString("편집", comment: ""),
                                style: .H1_B_130
                            )
                        }
                    }
                }
            } else {
                // MARK: - History Search
                HistoryListSearchView(
                    dataStore: dataStore,
                    isSearching: $isSearching,
                    searchText: $searchText
                )
                .navigationBarBackButtonHidden(true)
            }
        }
        .padding(.horizontal, 20)
        .showTKAlert(
            isPresented: $isDialogShowing,
            style: .removeConversation(title: selectedConversation.title)
        ) {
            isDialogShowing = false
            
        } confirmButtonAction: {
            withAnimation {
                // TODO: cascading deletion 임시방편. SwiftData relationship 수정 필요.
                // Delete Content
                selectedConversation.content.forEach { content in
                    dataStore.removeItem(content)
                }
                // Delete Location
                if let location = selectedConversation.location {
                    dataStore.removeItem(location)
                }
                // Delete Conversation
                dataStore.removeItem(selectedConversation)
                isDialogShowing = false // TODO: 이거 필요한가? 중복된 코드 아닌가
            }
        } confirmButtonLabel: {
            HStack(spacing: 8) {
                BDText(text: NSLocalizedString("네, 삭제할래요", comment: ""), style: .H2_SB_135)
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
    var dataStore: TKSwiftDataStore
    internal var location: TKLocation
    @State internal var isCollapsed: Bool = false
    @Binding internal var selectedConversation: TKConversation
    @Binding internal var isEditing: Bool
    @Binding internal var isDialogShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if location.blockName != "위치정보없음" { // TODO: nil 값 확인 필요
                    Image(systemName: "location.fill")
                } else {
                    Image(systemName: "location.slash.fill")
                }
                
                BDText(text: location.blockName, style: .T3_B_125)
                    .foregroundColor(.GR8)
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
                    Image(systemName: "chevron.forward")
                        .rotationEffect(isCollapsed ? .degrees(90) : .degrees(0))
                        .font(
                            .system(
                                size: 17,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .padding(.trailing, 4)
                        .animation(.easeInOut, value: isCollapsed)
                }
                .disabled(isEditing)
            }
            
            // Each List Cell
            if !isCollapsed {
                ForEach(
                    dataStore.getLocationBasedConversations(
                        location: location
                    )
                    .sorted { $0.createdAt > $1.createdAt },
                    id: \.self
                ) { conversation in
                    NavigationLink {
                        CustomHistoryView(
                            historyViewType: .item,
                            conversation: conversation
                        )
                        
                    } label: {
                        CellItem(
                            conversation: conversation,
                            selectedConversation: $selectedConversation,
                            isEditing: $isEditing,
                            isDialogShowing: $isDialogShowing
                        )
                        .disabled(!isEditing)
                    }
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
    @Binding internal var selectedConversation: TKConversation
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
                                .foregroundStyle(.white, .red)
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
                
                VStack(alignment: .leading, spacing: -3) {
                    BDText(
                        text: conversation.title,
                        style: .H1_B_130
                    )
                    .foregroundStyle(Color.GR8)
                    
                    BDText(
                        text:conversation.createdAt.convertToDate(),
                        style: .H2_M_135
                    )
                    .foregroundColor(.GR4)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .opacity(isEditing ? 0 : 1)
                    .foregroundColor(.GR4)
                    .font(
                        .system(
                            size: 17,
                            weight: .bold,
                            design: .rounded
                        )
                    )
            }
            .frame(height: 60)
            .padding(.horizontal)
            .background(Color.GR1)
            .cornerRadius(16)
            .onTapGesture {
                if isRemoving && isEditing {
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
                        selectedConversation = conversation
                        isDialogShowing = true
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 14)
                        .background(Color.RED)
                        .cornerRadius(16)
                }
                .frame(height: 60)
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

#Preview {
    NavigationStack {
        HistoryListView()
    }
}


