//
//  TKListeningView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftUI

struct TKListeningView: View {
    @ObservedObject var store: TKConversationViewStore
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    store.blockButtonDoubleTap {
                        store.onBackToWritingChevronTapped()
                    }
                    
                } label: {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "chevron.left")
                                .fontWeight(.black)
                        }
                }
                .opacity(
                    store(\.answeredText).isEmpty
                    ? 1.0
                    : 0.0
                )
                .animation(
                    .easeInOut,
                    value: store(\.answeredText).isEmpty
                )
                .disabled(store(\.blockButtonDoubleTap))
                
                Spacer()
                
                Button {
                    store.onSaveConversationButtonTapped()
                } label: {
                    Text("종료")
                        .font(.headline)
                        .foregroundStyle(Color.gray700)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(Color.gray200)
                .opacity(
                    store(\.answeredText).isEmpty
                    ? 0.0
                    : 1.0
                )
                .animation(
                    .easeInOut,
                    value: store(\.answeredText).isEmpty
                )
            }
            .padding(.leading, 12)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            
            ScrollView {
                Text(store(\.questionText))
                    .font(
                        store(\.answeredText).isEmpty
                        ? .title
                        : .title3
                    )
                    .lineSpacing(
                        store(\.answeredText).isEmpty
                        ? 10
                        : 14
                    )
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.horizontal, 24)
                    .animation(
                        .easeInOut,
                        value: store(\.answeredText).isEmpty
                    )       
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) {
                scrollViewCurtainBuilder(
                    colors: [
                        .white,
                        .clear,
                    ],
                    .bottom,
                    .top
                )
                .frame(height: 40)
            }
            .frame(maxHeight: 250)
            
            if !store(\.answeredText).isEmpty {
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(store(\.answeredText))
                            .font(.title)
                            .bold()
                            .lineSpacing(14)
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .topLeading
                            )
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                            .animation(
                                nil,
                                value: store(\.answeredText)
                            )
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0)
                            .id("SCROLL_BOTTOM")
                    }
                    .overlay(alignment: .top) {
                        if store(\.answeredText).count > 50 {
                            scrollViewCurtainBuilder(
                                colors: [
                                    .OR5,
                                    .clear,
                                ],
                                .top,
                                .bottom
                            )
                            .frame(height: 50)
                        }
                    }
                    // MARK: Scroll Position Here
                    .onChange(of: store(\.answeredText)) { _, newValue in
                        if newValue.count > 50 {
                            withAnimation {
                                proxy.scrollTo(
                                    "SCROLL_BOTTOM",
                                    anchor: .top
                                )
                            }
                        }
                    }
                    .frame(
                        maxHeight: UIScreen.main.bounds.height * 0.55
                    )
                    .scrollIndicators(.hidden)
                    .background {
                        Rectangle()
                            .fill(Color.OR6)
                            .ignoresSafeArea(edges: .bottom)
                    }
                    .padding(.top, 16)
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .push(from: .top)
                    )
                )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottom) {
            if store(\.conversationStatus) == .recording {
                bottomListeningButtonBuilder()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)
                        )
                    )
            }
        }
    }
    
    private func scrollViewCurtainBuilder(
        colors: [Color],
        _ startPoint: UnitPoint,
        _ endPoint: UnitPoint
    ) -> LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    private func bottomListeningButtonBuilder() -> some View {
        HStack(spacing: 24) {
            Spacer()
            
            if store(\.answeredText).isEmpty {
                Text("듣고 있어요")
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .frame(minWidth: 110, minHeight: 50)
                    .background {
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(
                                cornerRadius: 22,
                                style: .continuous
                            )
                            
                            Rectangle()
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(45))
                                .offset(x: 3)
                        }
                        .compositingGroup()
                        .foregroundStyle(Color.OR5)
                    }
            }
            
            Button {
                store.blockButtonDoubleTap {
                    store.onStopRecordingButtonTapped()
                }
                
            } label: {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(
                        store(\.answeredText).isEmpty
                        ? Color.OR5
                        : Color.white
                    )
                    .overlay {
                        Image(systemName: "chevron.right")
                            .opacity(
                                store(\.answeredText).isEmpty
                                ? 0.0
                                : 1.0
                            )
                            .foregroundStyle(Color.OR6)
                            .scaleEffect(1.4)
                            .fontWeight(.bold)
                    }
            }
            .disabled(store(\.blockButtonDoubleTap))
        }
        .padding(.trailing, 24)
    }
}

struct TKListeningView_Preview: PreviewProvider {
    static var previews: some View {
        TKConversationView(
            store: .init()
        )
    }
}
