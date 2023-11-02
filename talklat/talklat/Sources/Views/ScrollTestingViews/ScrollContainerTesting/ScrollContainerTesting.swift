//
//  ScrollTestingContainer.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/25.
//

import SwiftUI

struct ScrollContainerTesting: View {
    @State private var deviceHeight: CGFloat = 0
    @State private var topInset: CGFloat = 0
    @State private var bottomInset: CGFloat = 0
    @State private var currentViewHeight: CGFloat = 0
    
    @State private var isTopViewShown: Bool = false
    
    var body: some View {
        VStack {
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
                ? currentViewHeight // 임시방편
                : nil
            )
            .overlay(alignment: .bottom) {
                Button {
                    withAnimation(
                        .spring(
                            response: 0.5,
                            dampingFraction: 0.7,
                            blendDuration: 0.5
                        )
                    ) {
                        isTopViewShown = false
                    }
                } label: {
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .frame(width: 32, height: 10)
                        .foregroundColor(.gray500)
                }
                .padding(.vertical, 20)
            }
            
            // View 2
            ScrollContainerTextFieldView(
                isTopViewShown: $isTopViewShown,
                deviceHeight: $deviceHeight,
                topInset: $topInset,
                bottomInset: $bottomInset
            )
            .padding(.top, -8)
            .frame(
                height: isTopViewShown
                ? nil
                : currentViewHeight + topInset // 임시방편
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



struct ScrollTestingContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScrollContainerTesting()
    }
}
