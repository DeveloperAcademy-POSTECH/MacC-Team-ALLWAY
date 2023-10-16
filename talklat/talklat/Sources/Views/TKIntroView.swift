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
    
    var body: some View {
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
        .onAppear {
            gyroMotionStore.startDeviceMotion()
        }
        .onChange(of: gyroMotionStore.faced) { facedStatus in
            switch facedStatus {
            case .myself:
                appViewStore.communicationStatusSetter(.writing)
                HapticManager.sharedInstance.generateHaptic(.sttToText)
            case .opponent:
                withAnimation {
                    appViewStore.communicationStatusSetter(.recording)
                }
                HapticManager.sharedInstance.generateHaptic(.textToStt)
            }
        }
    }
}

struct TKIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKIntroView(appViewStore: .makePreviewStore(condition: { store in
            store.questionTextSetter("")
            store.voiceRecordingAuthSetter(.authCompleted)
            store.communicationStatusSetter(.writing)
        }))
    }
}
