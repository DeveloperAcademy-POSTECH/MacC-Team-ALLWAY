//
//  SectionIndexTitles.swift
//  talklat
//
//  Created by 신정연 on 11/10/23.
//

import SwiftUI

// MARK: 텍스트 대치 리스트의 목차 부분
struct SectionIndexTitles: View {
    @State private var selectedIndex: Int?
    @State private var feedbackGenerator = UISelectionFeedbackGenerator()
    let proxy: ScrollViewProxy
    
    init(proxy: ScrollViewProxy) {
        self.proxy = proxy
    }
    
    var body: some View {
        VStack {
            ForEach(0..<Constants.SectionIndexTitles.count, id: \.self) { index in
                Text(Constants.SectionIndexTitles[index])
                    .font(.system(size: 11))
                    .fontWeight(.semibold)
                    .foregroundColor(.OR6)
                    .cornerRadius(5)
                    .onTapGesture {
                        selectedIndex = index
                        feedbackGenerator.selectionChanged()
                        proxy.scrollTo(Constants.SectionIndexTitles[index])
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let touchPoint = value.location
                    let totalHeight = UIScreen.main.bounds.height
                    let index = min(Constants.SectionIndexTitles.count - 1, max(0, Int((touchPoint.y / totalHeight) * CGFloat(Constants.SectionIndexTitles.count))))
                    selectedIndex = index
                    feedbackGenerator.selectionChanged()
                    proxy.scrollTo(Constants.SectionIndexTitles[index])
                }
                .onEnded { _ in
                    selectedIndex = nil
                }
        )
    }
}
