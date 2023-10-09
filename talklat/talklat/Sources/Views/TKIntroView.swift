//
//  AWIntroView.swift
//  talklat
//
//  Created by Celan on 2023/10/05.
//

import SwiftUI

struct TKIntroView: View {
    @StateObject private var appViewStore: AppViewStore = AppViewStore(
        communicationStatus: .writing,
        questionText: ""
    )
    
    var body: some View {
        switch appViewStore.communicationStatus {
        case .writing:
            TKWritingView(appViewStore: appViewStore)
        case .recording:
            TKRecordingView(appViewStore: appViewStore)
        }
    }
}

struct TKIntroView_Previews: PreviewProvider {
    static var previews: some View {
        TKIntroView()
    }
}
