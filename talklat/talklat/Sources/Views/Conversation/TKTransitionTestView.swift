//
//  TKTransitionTestView.swift
//  talklat
//
//  Created by Celan on 10/31/23.
//

import SwiftUI

struct TKTransitionTestView: View {
    enum Status {
        case one, two, three
    }
    @State private var status: Status = .one
    
    var body: some View {
        switch status {
        case .one:
            Text("?")
                .transition(.asymmetric(insertion: .opacity, removal: .slide))
                .animation(.easeInOut, value: status)
                .task {
                    try? await Task.sleep(for: .seconds(1.2))
                    withAnimation {
                        status = .two
                    }
                }
            
        case .two:
            NavigationStack {
                Text("2")
            }
            
        case .three:
            Text("4")
        }
    }
}

#Preview {
    TKTransitionTestView()
}
