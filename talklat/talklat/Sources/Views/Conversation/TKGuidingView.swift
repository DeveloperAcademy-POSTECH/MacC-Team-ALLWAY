//
//  TKGuidingView.swift
//  talklat
//
//  Created by Celan on 10/31/23.
//

import SwiftUI

struct TKGuidingView: View {
    @ObservedObject var store: TKConversationViewStore
    @State private var circleTrim: CGFloat = 0.0
    @State private var flag: Bool = false
    
    let guideTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let guide: String =
    """
    해당 화면이 종료되면
    음성인식이 시작됩니다.
    제 글을 읽고 또박또박 말씀해 주세요.
    """
    
    var guidingMessage: String = UserDefaults.standard.string(
        forKey: "guidingMessage"
    ) ?? String("안녕하세요. \n저는 청각장애를 \n가지고 있습니다.")
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                store.onGuideCancelButtonTapped()
            } label: {
                Text("취소")
                    .font(.headline)
                    .bold()
            }
            
            Spacer()
                .frame(maxHeight: 60)
            
            Text(guidingMessage)
                .font(.largeTitle)
                .bold()
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
            
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .padding(.bottom, 32)
            
            Text(guide)
                .font(.title2)
                .bold()
                .lineSpacing(10)
            
            Spacer()
        }
        
        .padding(.horizontal, 24)
        .overlay(alignment: .bottom) {
            HStack {
                Spacer()
                
                Circle()
                    .trim(from: 0, to: circleTrim)
                    .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.default, value: circleTrim)
            }
            .onAppear {
                flag.toggle()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .foregroundStyle(Color.white)
        .background { Color.OR5.ignoresSafeArea() }
        .onReceive(guideTimer) { _ in
            if circleTrim <= 1.0 {
                circleTrim += 0.025
            } else if circleTrim >= 1.0 {
                guideTimer.upstream.connect().cancel()
                store.onGuideTimeEnded()
            }
        }
    }
}

struct TKGuidingView_Preview: PreviewProvider {
    static var previews: some View {
        TKGuidingView(store: .init())
    }
}
