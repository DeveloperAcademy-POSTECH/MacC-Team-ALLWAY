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
    @Published private(set) var currentAuthStatus: AuthStatus = .splash
    @Published private(set) var hasGuidingMessageShown: Bool = false
    @Published public var historyItems: [HistoryItem] = []
    @Published var recognitionCount: Int = 0
    
    @Published public var deviceHeight: CGFloat = CGFloat(0)
    @Published public var isHistoryViewShown: Bool = false
    @Published public var isScrollDisabled: Bool = true
    @Published public var messageOffset: CGSize = .zero
    @Published public var isMessageTapped: Bool = false
    
    public let questionTextLimit: Int = 160
    
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
        withAnimation(.easeIn(duration: 0.15)) {
            communicationStatus = .recording
        }
    }
    
    public func stopSpeechRecognizeButtonTapped() {
        withAnimation(.easeIn(duration: 0.15)) {
            communicationStatus = .writing
        }
    }
    
    public func onWritingViewDisappear() {
        // TKHistoryView로 user's text 전달
        if !questionText.isEmpty {
            let newHistoryItem = HistoryItem(
                id: UUID(),
                text: questionText,
                type: .question
            )
            historyItems.append(newHistoryItem)
        }
        print(questionText)
    }
    
    public func onRecordingViewDisappear() {
        if let answeredText = answeredText,
           !answeredText.isEmpty {
            let answerItem = HistoryItem(id: UUID(), text: answeredText, type: .answer)
            historyItems.append(answerItem)
        }
    }
    
    public func removeQuestionTextButtonTapped() {
        questionText = ""
    }
    
    public func swipeGuideMessageTapped() {
        isMessageTapped = true
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {
            self.isMessageTapped = false
        }
    }
    
    public func swipeGuideMessageDragged(_ gesture: DragGesture.Value) {
        if gesture.translation.height > -50 {
            messageOffset.height = gesture.translation.height
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.15
            ) {
                self.messageOffset.height = .zero
            }
        }
    }
    
    public func onIntroViewAppear(_ proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo("TKIntroView")
        }
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
    
    public func historyViewSetter(_ shouldShow: Bool) {
        if shouldShow {
            isHistoryViewShown = true
        } else {
            isHistoryViewShown = false
        }
    }
    
    public func scrollDestinationSetter(
        scrollReader: ScrollViewProxy,
        destination: String
    ) {
        scrollReader.scrollTo(destination, anchor: .top)
    }
    
    public func scrollAvailabilitySetter(_ isEnabled: Bool) {
        if isEnabled {
            isScrollDisabled = true
        } else {
            isScrollDisabled = false
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
        withAnimation(.easeIn(duration: 0.15)) {
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
        withAnimation {
            currentAuthStatus = status
        }
    }
}

// MARK: MAKE INSTANCES
extension AppViewStore {
    static func makePreviewStore(
        condition: @escaping (AppViewStore) -> Void
    ) -> AppViewStore {
        let appViewStore = AppViewStore(
            communicationStatus: .writing,
            questionText: ""
        )
        condition(appViewStore)
        return appViewStore
    }
}
