//
//  TKHistoryView.swift
//  talklat
//
//  Created by Celan on 2023/10/16.
//

import SwiftUI

struct TKHistoryView: View {
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        ZStack {
            ScrollView {
                // TODO: - ForEach의 data 아규먼트 수정
                // TODO: - 각 Color 값을 디자인 시스템 값으로 추후 수정
                ForEach(0..<100) { int in
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
            }
            .padding(.top, 16)
            .background { Color(.systemGray6) }
            
            VStack {
                VStack(spacing: 12) {
                    Text("텍스트 작성 페이지로 돌아가기")
                        .font(.system(size: 12, weight: .bold))
                        .bold()
                        .padding(.top, 24)
                    
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .frame(width: 32, height: 10)
                        .padding(.bottom, 10)
                }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 100,
                        alignment: .top
                    )
                    .foregroundColor(Color(.systemGray))
                    .background {
                        Rectangle()
                            .fill(Color.white)
                            .shadow(
                                color: Color(.systemGray4),
                                radius: 30,
                                y: -1
                            )
                    }
            }
            .frame(
                maxHeight: .infinity,
                alignment: .bottom
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("히스토리")
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

struct TKHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TKHistoryView(appViewStore: .makePreviewStore(condition: { store in
                
            }))
        }
    }
}
