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
    @Published private(set) var currentAuthStatus: AuthStatus = .authIncompleted
    @Published private(set) var hasGuidingMessageShown: Bool = false
    
    public let questionTextLimit: Int = 55
    
    // MARK: INIT
    init(
        communicationStatus: CommunicationStatus,
        questionText: String,
        currentAuthStatus: AuthStatus
    ) {
        self.communicationStatus = communicationStatus
        self.questionText = questionText
        self.currentAuthStatus = currentAuthStatus
    }
    
    // MARK: HELPERS
    public func enterSpeechRecognizeButtonTapped() {
        withAnimation(.easeIn(duration: 0.75)) {
            communicationStatus = .recording
        }
    }
    
    public func stopSpeechRecognizeButtonTapped() {
        withAnimation(.easeIn(duration: 0.75)) {
            communicationStatus = .writing
        }
    }
    
    public func removeQuestionTextButtonTapped() {
        questionText = ""
    }

    public func onWritingViewAppear() {
        if questionText.isEmpty { }
        else { questionText = "" }
    }
    
    public func onRecordingViewAppear() {
        // TODO: 추후 Transcript 를 배열 등으로 저장하게 되면 해당 속성의 count 등으로 로직 업데이트 예정
        if !hasGuidingMessageShown,
           answeredText != nil {
            hasGuidingMessageShown = true
        }
    }
    
    public func bindingTextField(_ str: String) {
        if str.count > questionTextLimit {
            questionText = String(str.prefix(questionTextLimit))
        } else {
            questionText = str
        }
    }
}

// MARK: public Setters
extension AppViewStore {
    public func communicationStatusSetter(_ status: CommunicationStatus) {
        withAnimation(.easeIn(duration: 0.75)) {
            communicationStatus = status
        }
    }
    
    public func questionTextSetter(_ str: String) {
        questionText = str
    }
    
    public func answeredTextSetter(_ str: String) {
        answeredText = str
    }
    
    public func voiceRecordingAuthSetter(_ status: AuthStatus) {
        currentAuthStatus = status
    }
}

// MARK: MAKE INSTANCES
extension AppViewStore {
    static func makePreviewStore(
        condition: @escaping (AppViewStore) -> Void
    ) -> AppViewStore {
        let appViewStore = AppViewStore(
            communicationStatus: .writing,
            questionText: "",
            currentAuthStatus: .authCompleted
        )
        condition(appViewStore)
        return appViewStore
    }
}
