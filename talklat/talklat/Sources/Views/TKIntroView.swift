//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

struct TKIntroView: View {
    @StateObject var gyroMotionStore: GyroScopeStore = GyroScopeStore()
    @ObservedObject var appViewStore: AppViewStore
    
    var body: some View {
        Group {            
            switch appViewStore.communicationStatus {
            case .writing:
                TKWritingView(appViewStore: appViewStore)
            case .recording:
                TKRecordingView(appViewStore: appViewStore)
            }
        }
        .onAppear {
            gyroMotionStore.startDeviceMotion()
        }
        .onChange(of: gyroMotionStore.faced) { facedStatus in
            switch facedStatus {
            case .myself:
                appViewStore.communicationStatusSetter(.writing)
            case .opponent:
                appViewStore.communicationStatusSetter(.recording)
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
