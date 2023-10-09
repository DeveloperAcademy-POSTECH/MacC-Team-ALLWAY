//
//  AppViewManager.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

final class AppViewStore: ObservableObject {
    enum CommunicationStatus: String {
        case recording
        case writing
    }
    
    @Published private(set) var communicationStatus: CommunicationStatus
    @Published private(set) var questionText: String
    @Published private(set) var answeredText: String?
    
    public let questionTextLimit: Int = 55
    
    // MARK: INIT
    init(
        communicationStatus: CommunicationStatus,
        questionText: String
    ) {
        self.communicationStatus = communicationStatus
        self.questionText = questionText
    }
    
    // MARK: HELPERS
    public func enterSpeechRecognizeButtonTapped() {
        withAnimation {
            communicationStatus = .recording
        }
        
    }
    
    public func stopSpeechRecognizeButtonTapped() {
        withAnimation {
            communicationStatus = .writing
        }
    }
    
    public func removeQuestionTextButtonTapped() {
        questionText = ""
    }
    
    public func bindingTextField(_ str: String) {
        if str.count > questionTextLimit {
            questionText = String(str.prefix(questionTextLimit))
        } else {
            questionText = str
        }
    }
    
    public func communicationStatusSetter(_ status: CommunicationStatus) {
        communicationStatus = status
    }
    
    public func questionTextSetter(_ str: String) {
        questionText = str
    }
}

// MARK: MAKE INSTANCES
extension AppViewStore {
    static func makePreviewStore(
        condition: @escaping (AppViewStore) -> Void
    ) -> AppViewStore {
        let appViewStore = AppViewStore(communicationStatus: .writing, questionText: "")
        condition(appViewStore)
        return appViewStore
    }
}
