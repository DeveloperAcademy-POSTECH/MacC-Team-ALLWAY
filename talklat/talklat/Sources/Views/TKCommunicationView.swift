//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

struct TKCommunicationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var gyroMotionStore: GyroScopeStore = GyroScopeStore()
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        VStack {
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
        // TODO: - 디자인 팀이랑 상의 후 패딩 값 조절 (전체 지우기, swipeGuideMessage의 거리 등)
//        .safeAreaInset(edge: .top) {
//            Rectangle()
//                .fill(.white)
//            // TODO: - deviceTopSafeAreaInset 값으로 변경
//                .frame(height: 50)
//        }
        .onAppear {
            gyroMotionStore.detectDeviceMotion()
        }
        .onChange(of: gyroMotionStore.faced) { facedStatus in
            switch facedStatus {
            case .myself:
                appViewStore.communicationStatusSetter(.writing)
                HapticManager.sharedInstance.generateHaptic(.rigidTwice)
            case .opponent:
                appViewStore.communicationStatusSetter(.recording)
                HapticManager.sharedInstance.generateHaptic(.success)
            }
        }
        .onChange(of: scenePhase) { _ in
            Color.colorScheme = UITraitCollection.current.userInterfaceStyle
        }
    }
}

struct TKIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKCommunicationView(
            appViewStore: .makePreviewStore(condition: { store in
                store.questionTextSetter("")
                store.voiceRecordingAuthSetter(.authCompleted)
                store.communicationStatusSetter(.writing)
            })
        )
    }
}



