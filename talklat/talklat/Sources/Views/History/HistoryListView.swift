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
    
    private var dataStore: TKSwiftDataStore = TKSwiftDataStore()
    
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
            .navigationBarBackButtonHidden(
                isSearching ? true : false
            )
            .disabled(isEditing ? true : false)
            
            Spacer()
            
            // MARK: - History List
            if !isSearching {
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
                    .navigationBarBackButtonHidden(true)
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
                                        text: "홈",
                                        style: .H1_B_130
                                    )
                                }
                                .fontWeight(.medium)
                            }
                            .tint(Color.OR6)
                        }
                        
                        // Navigation Title
                        ToolbarItem(placement: .principal) {
                            BDText(
                                text: "히스토리",
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
                                    text: isEditing ? "완료" : "편집",
                                    style: .H1_B_130
                                )
                            }
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
            }
        }
        .onAppear {
            
        }
        .padding(.horizontal, 20)
        .showTKAlert(
            isPresented: $isDialogShowing,
            style: .removeConversation(title: selectedConversation.title)
        ) {
            isDialogShowing = false
            withAnimation {
                isEditing = false
            }
        } confirmButtonAction: {
            withAnimation {
                dataStore.removeItem(selectedConversation)
                isDialogShowing = false
                isEditing = false
            }
            
        } confirmButtonLabel: {
            HStack(spacing: 8) {
                BDText(text: "네, 삭제할래요", style: .H2_SB_135)
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
                ForEach(
                    dataStore.getLocationBasedConversations(location: location)
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
                
                VStack(alignment: .leading, spacing: 3) {
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

// TODO: 히스토리뷰 스토어 생성 후 TKDialogBuilder로 분리
/// enum case .destruction (빨간색), .cancel (주황색) 필요
struct CustomDialog: View {
    var dataStore: TKSwiftDataStore
    
    @Binding internal var selectedConversation: TKConversation
    @Binding internal var isDialogShowing: Bool
    @Binding internal var isEditing: Bool
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
                
                Text("대화 삭제")
                    .foregroundColor(.GR9)
                    .font(.system(size: 17, weight: .bold))
                
                Text("\"\(selectedConversation.title)\"에서 저장된\n모든 데이터가 삭제됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.GR6)
                    .font(.system(size: 15, weight: .medium))
                
                HStack {
                    Button {
                        isDialogShowing = false
                        isEditing = false
                        
                    } label: {
                        Text("아니요, 취소할래요")
                            .foregroundColor(.GR6)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .background(Color.GR2)
                            .cornerRadius(16)
                    }
                    
                    Button {
                        // Delete
                        dataStore.removeItem(selectedConversation)
                        isDialogShowing = false
                        isEditing = false
                    } label: {
                        Text("네, 삭제할래요")
                            .foregroundColor(.BaseBGWhite)
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
}

#Preview {
    NavigationStack {
        HistoryListView()
    }
}


