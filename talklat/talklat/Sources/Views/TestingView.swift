//
//  TestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/18.
//

import SwiftUI

struct TestingView: View {
    @State private var offset = CGFloat.zero
    @State private var dragOffset = CGFloat.zero
    @State private var viewHeight = CGFloat.zero
    
    var body: some View {
        GeometryReader { fullgeo in
            ZStack(alignment: .top) {
                TopView()
                    .frame(height: fullgeo.size.height)
                    .gesture( DragGesture(minimumDistance: 30)
                        .onChanged { value in
                            dragOffset = .zero
                        }
                        .onEnded { value in
                            withAnimation(.easeOut) {
                                dragOffset = .zero
                                offset += value.predictedEndTranslation.height
                                
                                if offset < (viewHeight - fullgeo.size.height / 2) {
                                    dragOffset = viewHeight
                                    return
                                }
                                
                                offset = max(min(offset, 0), (viewHeight - fullgeo.size.height))
                            }
                        }
                    )
                
                BottomView()
                    .overlay(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                viewHeight = geo.size.height
                            }
                        }
                    )
                    .offset(y: offset + dragOffset)
                    .gesture( DragGesture(minimumDistance: 30)
                        .onChanged { value in
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            withAnimation(.easeOut) {
                                dragOffset = .zero
                                offset += value.predictedEndTranslation.height
                                
                                if offset < -(viewHeight - fullgeo.size.height / 2) {
                                    dragOffset = -viewHeight
                                    return
                                }
                                
                                offset = max(min(offset, 0), -(viewHeight - fullgeo.size.height))
                            }
                        }
                    )
            }
        }
//        .onChange(of: dragOffset) { _ in
//            print("dragOffset: ", dragOffset)
//            print("offset: ", offset)
//            print("viewHeight: ", viewHeight)
//            print("--------------------------")
//        }
    }
}

struct BottomView: View {
    var body: some View {
        VStack {
            Text("View Top").font(.headline)
            ForEach(0..<10) { _ in
                Text("Content")
                    .frame(width: 200, height: 100)
                    .background(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}

struct TopView: View {
    var body: some View {
        Text("View Bottom").font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.orange)
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
