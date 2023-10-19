//
//  AnotherTestingView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/18.
//

import SwiftUI

struct AnotherTestingView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            FirstView()
            SecondView()
        }
    }
}

struct FirstView: View {
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(1 ..< 50) { _ in
                    Text("numbers")
                }
                .frame(width: 500, height: 1200)
            }
            .background(.red)
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        withAnimation {
                            proxy.scrollTo(1, anchor: .top)
                        }
                    }
            )
        }
    }
}

struct SecondView: View {
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 500, height: 700)
            }
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        withAnimation {
                            proxy.scrollTo(0, anchor: .bottom)
                        }
                    }
            )
        }
    }
}


struct AnotherTestingView_Previews: PreviewProvider {
    static var previews: some View {
        AnotherTestingView()
    }
}
