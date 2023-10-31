//
//  TestingFullScreenCover.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/27.
//

import SwiftUI

struct FullScreenCoverTesting: View {
    @ObservedObject var appViewStore: AppViewStore
    
    @State private var isPresented: Bool = false
   
    var body: some View {
        Button("Show fullscreen cover") {
            isPresented = true
        }
        .buttonStyle(.borderedProminent)
        .fullScreenCover(isPresented: $isPresented) {
            FullScreenCoverView(appViewStore: appViewStore)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct FullScreenCoverView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var appViewStore: AppViewStore
    
    @State private var deviceHeight: CGFloat = 0
    @State private var topInset: CGFloat = 0
    @State private var bottomInset: CGFloat = 0
    @State private var currentViewHeight: CGFloat = 0
    
    @State private var isTopViewShown: Bool = false
    
    @State private var scrollTotalOffset: CGPoint = .zero
    
    var body: some View {
        VStack {
            HStack {
                Button("cancel") {
                    presentationMode
                        .wrappedValue.dismiss()
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // View 1
            TestingTKHistoryView(
                appViewStore: AppViewStore(
                    communicationStatus: .writing,
                    questionText: "String",
                    currentAuthStatus: .authCompleted
                ),
                isTopViewShown: $isTopViewShown
            )
            .frame(
                height: isTopViewShown
                ? deviceHeight
                : nil
            )
            // 임시 내려가기 버튼
            .overlay {
                VStack {
                    Spacer()
                    
                    Button {
                        isTopViewShown = false
                    } label: {
                        Image(systemName: "chevron.compact.down")
                            .resizable()
                            .frame(width: 32, height: 10)
                            .foregroundColor(.gray500)
                    }
                    .padding(.vertical, 50)
                    .padding(.bottom, -10)
                }
            }
            
//            FullScreenCoverTopView(
//                isTopViewShown: $isTopViewShown,
//                deviceHeight: $deviceHeight,
//                topInset: $topInset,
//                bottomInset: $bottomInset
//            )
//            .ignoresSafeArea(edges: .bottom)
//            .frame(
//                height: isTopViewShown
//                ? currentViewHeight
//                : nil
//            )
            
            // View 2
            FullScreenCoverBottomView(
                isTopViewShown: $isTopViewShown,
                deviceHeight: $deviceHeight,
                topInset: $topInset,
                bottomInset: $bottomInset,
                scrollTotalOffset: $scrollTotalOffset
            )
            .frame(
                height: isTopViewShown
                ? nil
                : deviceHeight
            )
        }
        .background {
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        deviceHeight = geo.size.height
                        topInset = geo.safeAreaInsets.top
                        bottomInset = geo.safeAreaInsets.bottom
                    }
            }
        }
        .onAppear {
            currentViewHeight = deviceHeight + topInset + bottomInset
            print("device: ", deviceHeight)
            print("topInset: ", topInset)
            print("bottomInset: ", bottomInset)
            print("-----------------")
        }
        .onChange(of: isTopViewShown) { _ in
            if isTopViewShown {
                hideKeyboard()
            }
        }

    }
}




struct TestingFullScreenCover_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FullScreenCoverTesting(appViewStore: .makePreviewStore(condition: { AppViewStore in
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
