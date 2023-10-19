//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

struct TKHistoryView: View {
    @ObservedObject var appViewStore: AppViewStore
    @Binding var isHistoryViewShown: Bool
    @Binding var deviceHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                // TODO: - ForEach의 data 아규먼트 수정
                // TODO: - 각 Color 값을 디자인 시스템 값으로 추후 수정
                ForEach(0 ..< 100) { int in
                    if int % 2 == 0 {
                        VStack(alignment: .leading) {
                            Image(systemName: "waveform.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(.systemGray))
                                .padding(.leading, 4)
                            
                            Text("일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠")
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.white))
                                        .frame(maxHeight: 100)
                                }
                        }
                        .padding(.horizontal, 24)
                        
                    } else {
                        Text("일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray4))
                                    .frame(maxHeight: 100)
                            }
                            .padding(.trailing, 24)
                            .padding(.leading, 68)
                            .padding(.top, 32)
                    }
                }
                .padding(.top, 10)
            }
            // FIXME: deviceTopSafeAreaInset 값으로 변경
            .padding(.top, 100)
            .background { Color(.systemGray6 )}
            
            swipeGuideMessage(type: .swipeToBottom)
        }
        .frame(height: deviceHeight)
        .ignoresSafeArea()
        .navigationTitle(
            isHistoryViewShown ? "히스토리" : ""
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color(.systemGray6),
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
    }
}





//struct TKHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            TKHistoryView(
//                appViewStore: .makePreviewStore(condition: { store in
//
//            }),
//                isHistoryViewShown: .constant(true)
//            )
//        }
//    }
//}