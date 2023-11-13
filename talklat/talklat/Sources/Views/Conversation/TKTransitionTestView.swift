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
    @State private var flag: Bool = false
    
    @Namespace var NAMETEST
    
    var body: some View {
        VStack {
            
            Button {
                withAnimation {
                    flag.toggle()
                }
            } label: {
                Text("Toggle")
            }
            
            if flag {
                Text("Hi")
                    .matchedGeometryEffect(id: "ID", in: NAMETEST)
            } else {
                TKTransitionTestView2()
            }
        }
        .publishNamespace(NAMETEST)
    }
}

struct TKTransitionTestView2: View {
    @Environment(\.namespace) var NAMETEST
    
    var body: some View {
        VStack {
            Text("??")
                .matchedGeometryEffect(id: "ID", in: NAMETEST)
        }
    }
}

#Preview {
    TKTransitionTestView()
}
