//
//  TKGuidingView.swift
//  talklat
//
//  Created by Celan on 10/31/23.
//

import SwiftUI

struct TKGuidingView: View {
    @ObservedObject var store: ConversationViewStore
    @State private var circleTrim: CGFloat = 0.0
    
    let guideTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let guide: String =
    """
    이 앱은 당신이 말하는 것을
    제가 들을 수 있도록 도와줄 거예요.
    
    이 화면이 꺼지면, 제 질문을 읽고
    크고 또박또박 말씀해주시기를
    부탁드릴게요.
    """
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                store.onGuideCancelButtonTapped()
            } label: {
                Text("취소")
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
                .frame(maxHeight: 60)
            
            Text("안녕하세요.\n저는 청각장애를\n가지고 있습니다.")
                .font(.largeTitle)
                .bold()
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .padding(.top, 20)
                .padding(.bottom, 40)
            
            Text(guide)
                .font(.title3)
                .bold()
            
            Spacer()
            
            HStack {
                Circle()
                    .trim(from: 0, to: circleTrim)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.default, value: circleTrim)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .background { Color.accentColor.ignoresSafeArea() }
        .onReceive(guideTimer) { _ in
            if circleTrim <= 1.1 {
                circleTrim += 0.05
            } else if circleTrim >= 1.1 {
                guideTimer.upstream.connect().cancel()
                withAnimation {
                    store.onGuideTimeEnded()
                }
            }
        }
    }
}

struct TKGuidingView_Preview: PreviewProvider {
    static var previews: some View {
        TKGuidingView(store: .init(conversationState: .init(conversationStatus: .guiding)))
    }
}
