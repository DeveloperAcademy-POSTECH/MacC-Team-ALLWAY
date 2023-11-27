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
                    .navigationTitle("히스토리")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("홈")
                                }
                                .fontWeight(.medium)
                            }
                            .tint(Color.OR6)
                        }
                        
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
                                        isEditing.toggle()
                                    }
                                } label: {
                                    Text("편집")
                                        .fontWeight(.medium)
                                }
                                .tint(Color.OR6)
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
                Text("네, 삭제할래요")
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
                Image(systemName: "location.fill")
                Text(location.blockName)
                    .foregroundColor(.GR8)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, -5)
                
                Spacer()
                
                // Collapse Button
                Button {
                    print("--> persistentID: ", location.persistentModelID)
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
                    Text(conversation.title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.GR8)
                    
                    Text(conversation.createdAt.convertToDate())
                        .foregroundStyle(Color.GR4)
                        .font(.system(size: 15, weight: .medium))

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
                        .foregroundColor(.BaseBGWhite)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 14)
                        .background(.red)
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


