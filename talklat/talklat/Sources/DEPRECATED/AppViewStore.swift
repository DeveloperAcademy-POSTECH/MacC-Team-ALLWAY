//
//  AppViewManager.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import SwiftUI

//final class AppViewStore: ObservableObject {
//    enum CommunicationStatus: String {
//        case recording
//        case writing
//    }
//    
//    @Published private(set) var communicationStatus: CommunicationStatus = .writing
//    @Published private(set) var questionText: String = ""
//    @Published private(set) var answeredText: String?
//    @Published private(set) var currentAuthStatus: AuthStatus = .splash
//    @Published private(set) var hasGuidingMessageShown: Bool = false
//    @Published public var historyItems: [HistoryItem] = []
//    @Published public var recognitionCount: Int = 0
//    
//    public let questionTextLimit: Int = 160
//    
//    // MARK: HELPERS
//    public func enterSpeechRecognizeButtonTapped() {
//        withAnimation(.easeIn(duration: 0.15)) {
//            communicationStatus = .recording
//        }
//    }
//    
//    public func stopSpeechRecognizeButtonTapped() {
//        withAnimation(.easeIn(duration: 0.15)) {
//            communicationStatus = .writing
//        }
//    }
//    
//    public func onWritingViewDisappear() {
//        // TKHistoryView로 user's text 전달
//        if !questionText.isEmpty {
//            let newHistoryItem = HistoryItem(
//                id: UUID(),
//                text: questionText,
//                type: .question,
//                createdAt: Date()
//            )
//            historyItems.append(newHistoryItem)
//        }
//        print(questionText)
//    }
//    
//    public func onRecordingViewDisappear() {
//        if let answeredText = answeredText,
//           !answeredText.isEmpty {
//            let answerItem = HistoryItem(
//                id: UUID(),
//                text: answeredText,
//                type: .answer,
//                createdAt: Date()
//            )
//            historyItems.append(answerItem)
//        }
//    }
//    
//    public func removeQuestionTextButtonTapped() {
//        questionText = ""
//    }
//    
//    public func onWritingViewAppear() {
//        if questionText.isEmpty { }
//        else { questionText = "" }
//    }
//    
//    public func onRecordingViewAppear() {
//        // TODO: 추후 Transcript 를 배열 등으로 저장하게 되면 해당 속성의 count 등으로 로직 업데이트 예정
//        if !hasGuidingMessageShown,
//           answeredText != nil {
//            hasGuidingMessageShown = true
//        }
//    }
//    
//    public func checkIfLastItem(_ item: HistoryItem) -> String {
//        if historyItems.last == item {
//            return "lastItem"
//        } else {
//            return item.text
//        }
//    }
//    
//    public func bindingTextField(_ str: String) {
//        if str.count > questionTextLimit {
//            questionText = String(str.prefix(questionTextLimit))
//        } else {
//            questionText = str
//        }
//    }
//}

// MARK: public Setters
//extension AppViewStore {
//    public func communicationStatusSetter(_ status: CommunicationStatus) {
//        withAnimation(.easeIn(duration: 0.15)) {
//            communicationStatus = status
//        }
//    }
//    
//    public func questionTextSetter(_ str: String) {
//        questionText = str
//    }
//    
//    public func answeredTextSetter(_ str: String) {
//        answeredText = str
//    }
//    
//    public func voiceRecordingAuthSetter(_ status: AuthStatus) {
//        withAnimation {
//            currentAuthStatus = status
//        }
//    }
//}
