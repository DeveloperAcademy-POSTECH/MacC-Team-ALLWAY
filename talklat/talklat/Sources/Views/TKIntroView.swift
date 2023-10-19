//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

// TODO: 애초부터 하나의 뷰 내에서 Component만 변화하고 있으니 View를 이렇게 분리할 필요가 없다고 본다
// 괜히 뷰 쪼개서 Animation, Transition 복잡하게 하지 말고 하던대로 해보자
import SwiftUI

struct TKIntroView: View {
    @StateObject var gyroMotionStore: GyroScopeStore = GyroScopeStore()
    @ObservedObject var appViewStore: AppViewStore
    
    @State var isMessageTextShown: Bool = false
    
    @Binding var deviceHeight: CGFloat
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.white)
                // FIXME: deviceTopSafeAreaInset 값으로 변경
                .frame(height: 40)
            
            VStack {
                if isMessageTextShown {
                    Text("위로 스와이프해서 내용을 더 확인하세요")
                        .font(.system(size: 11))
                        .foregroundColor(Color(.systemGray))
                        .padding(.top, 10)
                }
                
                swipeGuideMessage(type: .swipeToTop)
                    .onTapGesture {
                        withAnimation(
                            .easeOut(duration: 0.5)
                            .repeatCount(2, autoreverses: true)
                        ) {
                            isMessageTextShown = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.96) {
                                isMessageTextShown = false
                            }
                        }
                    }
            }
            // .background(.red) // 스와이프 메세지 탭 영역 확인
            .frame(height: 50)
            
            Group {
                switch appViewStore.communicationStatus {
                case .writing:
                    TKWritingView(appViewStore: appViewStore)
                        .transition(.opacity)
                    
                case .recording:
                    TKRecordingView(appViewStore: appViewStore)
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            gyroMotionStore.detectDeviceMotion()
        }
        .onChange(of: gyroMotionStore.faced) { facedStatus in
            switch facedStatus {
            case .myself:
                appViewStore.communicationStatusSetter(.writing)
                HapticManager.sharedInstance.generateHaptic(.rigidTwice)
            case .opponent:
                withAnimation {
                    appViewStore.communicationStatusSetter(.recording)
                }
                HapticManager.sharedInstance.generateHaptic(.success)
            }
        }
    }
}

struct TKIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKIntroView(
            appViewStore: .makePreviewStore(condition: { store in
                store.questionTextSetter("")
                store.voiceRecordingAuthSetter(.authCompleted)
                store.communicationStatusSetter(.writing)
            }),
            deviceHeight: .constant(CGFloat(0))
        )
    }
}
