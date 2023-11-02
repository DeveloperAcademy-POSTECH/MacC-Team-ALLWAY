//
//  NewTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

struct ScrollContainer: View {
    @ObservedObject var store: ConversationViewStore
    
    var body: some View {
        Group {
            if store(\.conversationStatus) == .guiding {
                TKGuidingView(store: store)
                    .frame(maxHeight: .infinity)
            } else {
                GeometryReader { _ in
                    VStack {
                        // View 1
                        if store(\.conversationStatus) == .writing {
                            TKHistoryView(store: store)
                                .frame(
                                    height: store(\.isTopViewShown)
                                    ? store(\.deviceHeight) + store(\.topInset) + store(\.bottomInset) // 임시방편
                                    : nil
                                )
                                .background { Color.gray100 }
                                .overlay(alignment: .bottom) {
                                    Button {
                                        withAnimation(
                                            .spring(
                                                response: 0.5,
                                                dampingFraction: 0.7,
                                                blendDuration: 0.5
                                            )
                                        ) {
                                            store.onScrollOffsetChanged(false)
                                        }
                                    } label: {
                                        Image(systemName: "chevron.compact.down")
                                            .resizable()
                                            .frame(width: 32, height: 10)
                                            .foregroundColor(.gray500)
                                    }
                                    .padding(.vertical, 30)
                                }
                        }
                        
                        // View 2
                        TKConversationView(store: store)
                            .frame(
                                height: store(\.isTopViewShown) && store(\.conversationStatus) == .writing
                                ? nil
                                : store(\.deviceHeight) + store(\.bottomInset) // 임시방편
                            )
                            .ignoresSafeArea(
                                .keyboard,
                                edges: .bottom
                            )
                    }
                    .onChange(of: store(\.isTopViewShown)) { _ in
                        if store(\.isTopViewShown) {
                            hideKeyboard()
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.clear)
                            .onAppear {
                                if let insets = UIApplication.shared.windows.first?.safeAreaInsets {
                                    store.onScrollContainerAppear(
                                        geo: geo,
                                        insets: insets
                                    )
                                }
                            }
                    }
                }
            }
            
            if !store(\.isTopViewShown) {
                if store(\.conversationStatus) == .writing {
                    startRecordingButtonBuilder()
                } else if store(\.conversationStatus) == .recording {
                    stopRecordButtonBuilder()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                        .background {
                            if !store(\.answeredText).isEmpty {
                                Color.accentColor
                                    .ignoresSafeArea(edges: .bottom)
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Button Components
extension ScrollContainer {
    // 전체 지우기 버튼
    private func eraseAllButtonBuilder() -> some View {
        Button {
            store.onEraseAllButtonTapped()
        } label: {
            Text("전체 지우기")
                .foregroundColor(
                    store(\.questionText).isEmpty
                    ? .gray.opacity(0.5)
                    : .gray
                )
        }
    }
    
    // Writing 뷰 버튼
    private func startRecordingButtonBuilder() -> some View {
        Button {
            self.hideKeyboard()
            withAnimation {
                store.onStartRecordingButtonTapped()
            }
        } label: {
            Text("음성 인식 전환")
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
                .background {
                    Capsule()
                        .foregroundColor(.accentColor)
                }
        }
    }
    
    // Recording 뷰 버튼
    private func stopRecordButtonBuilder() -> some View {
        Button {
            withAnimation {
                store.onStopRecordingButtonTapped()
            }
            
        } label: {
            Circle()
                .frame(width: 64, height: 64)
                .foregroundColor(
                    store(\.answeredText).isEmpty
                    ? .accentColor
                    : .gray100.opacity(0.8)
                )
        }
        .overlay(alignment: .top) {
            if store(\.answeredText).isEmpty {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .overlay {
                        Text("듣고 있어요")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .background(alignment: .bottom) {
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(45))
                            .offset(y: 5)
                    }
                    .frame(width: 150, height: 50)
                    .offset(y: -75)
                    .foregroundColor(.accentColor)
            }
        }
    }
}




//struct ScrollContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ScrollContainer(appViewStore: .makePreviewStore(condition: { store in
//                store.historyItems.append(.init(id: .init(), text: "대답1", type: .answer))
//                store.historyItems.append(.init(id: .init(), text: "질문1", type: .question))
//                store.historyItems.append(.init(id: .init(), text: "일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구일이삼사오육칠팔구1", type: .answer))
//            }))
//        }
//    }
//}
