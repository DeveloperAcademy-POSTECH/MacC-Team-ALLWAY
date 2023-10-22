//
//  NewTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/19.
//

import SwiftUI

struct ScrollContainer: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        GeometryReader { geo in // TKIntroView가 디바이스 height를 차지하도록 사용
            ScrollViewReader { proxy in /// 스크롤 위치 이동시 proxy 사용
                ScrollView {
                    VStack {
                        TKHistoryView(appViewStore: appViewStore)
                            .frame(maxWidth: .infinity)
                            .id("TKHistoryView")
                        
                        TKIntroView(appViewStore: appViewStore)
                            .padding(.top, -10) /// View 사이의 디폴트 공백 제거
                            .frame(
                                height: geo.size.height + geo.safeAreaInsets.magnitude
                            )
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .id("TKIntroView")
                    }
                    .onAppear {
                        appViewStore.onIntroViewAppear(proxy)
                        appViewStore.deviceHeight = geo.size.height
                    }
                }
                .scrollDisabled(appViewStore.isScrollDisabled)
                // MARK: - 상단 스와이프 영역
                .overlay {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(.red)
                                .opacity(0.001)
                            
                            VStack {
                                ZStack(alignment: .top) {
                                    Text("위로 스와이프해서 내용을 더 확인하세요")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(.systemGray2))
                                        .opacity(
                                            appViewStore.isMessageTapped
                                            ? 1.0
                                            : 0.0
                                        )
                                        .padding(.top, 10)
                                    
                                    swipeGuideMessage(type: .swipeToTop)
                                        .offset(
                                            y: appViewStore.isMessageTapped
                                            ? 30
                                            : 0
                                        )
                                        .onTapGesture {
                                            withAnimation(
                                                Animation.spring(
                                                    response: 0.24,
                                                    dampingFraction: 0.5,
                                                    blendDuration: 0.8
                                                )
                                                .speed(0.5)
                                            ) {
                                                appViewStore.swipeGuideMessageTapped()
                                            }
                                        }
                                }
                            }
                            .frame(height: 50)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                    .safeAreaInset(
                        edge: .top,
                        content: {
                            Rectangle()
                                .fill(.white)
                            // TODO: - deviceTopSafeAreaInset 값으로 변경
                                .frame(height: 50)
                        }
                    )
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                appViewStore.scrollAvailabilitySetter(false)
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    appViewStore.historyViewSetter(true)
                                    
                                    appViewStore.scrollDestinationSetter(
                                        scrollReader: proxy,
                                        destination: "TKHistoryView"
                                    )
                                }
                            }
                    )
                }
                // MARK: - 하단 스와이프 영역
                .overlay {
                    VStack {
                        Spacer()
                            .frame(maxHeight: .infinity)
                        
                        Rectangle()
                            .fill(.blue)
                            .opacity(0.01)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { gesture in
                                appViewStore.scrollAvailabilitySetter(true)
                                appViewStore.swipeGuideMessageDragged(gesture)
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    appViewStore.scrollDestinationSetter(
                                        scrollReader: proxy,
                                        destination: "TKIntroView"
                                    )
                                    
                                    appViewStore.historyViewSetter(false)
                                }
                            }
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
    }
}


