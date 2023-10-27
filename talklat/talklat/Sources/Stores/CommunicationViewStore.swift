//
//  CommunicationViewStore.swift
//  talklat
//
//  Created by Celan on 10/25/23.
//

import SwiftUI

final class CommunicationViewStore: ObservableObject {
    enum CommunicationStatus: Equatable {
        case recording
        case writing
    }
    
    struct CommunicationState: Equatable {
        var communicationStatus: CommunicationStatus
        var questionText: String = ""
        var answeredText: String = ""
        var hasGuidingMessageShown: Bool = false
        var hasChevronButtonTapped: Bool = false
        var historyItems: [HistoryItem] = []
        var historyItem: HistoryItem?
    }
    
    @Published private var viewState: CommunicationState
    public let questionTextLimit: Int = 160
    
    // MARK: init
    init(
        communicationState: CommunicationState
    ) {
        self.viewState = communicationState
    }
    
    public func callAsFunction<Value: Equatable>(_ keyPath: KeyPath<CommunicationState, Value>) -> Value {
        self.viewState[keyPath: keyPath]
    }
    
    // MARK: Helpers
    public func bindingQuestionText() -> Binding<String> {
        Binding(
            get: { self.viewState.questionText },
            set: {
                if $0.count > self.questionTextLimit {
                    self.updateState(
                        \.questionText,
                         with: String($0.prefix(self.questionTextLimit))
                    )
                } else {
                    self.updateState(
                        \.questionText,
                         with: $0
                    )
                }
            }
        )
    }
    
    public func onWritingViewAppear() {
        self.updateState(\.questionText, with: "")
        self.updateState(\.historyItem, with: HistoryItem(id: .init(), text: self(\.answeredText), type: .answer))
        self.updateState(\.communicationStatus, with: .writing)
        HapticManager.sharedInstance.generateHaptic(.rigidTwice)
        
    }
    
    public func onRecordingViewAppear() {
        self.updateState(\.answeredText, with: "")
        self.updateState(\.historyItem, with: HistoryItem(id: .init(), text: self(\.questionText), type: .question))
        
        self.updateState(\.communicationStatus, with: .recording)
        HapticManager.sharedInstance.generateHaptic(.success)

    }
    
    public func onStartRecordingButtonTapped() {
        self.onRecordingViewAppear()
    }
    
    public func onEraseAllButtonTapped() {
        self.updateState(\.questionText, with: "")
    }
    
    public func onStopRecordingButtonTapped() {
        self.onWritingViewAppear()
    }
    
    public func onChevronButtonTapped() {
        self.updateState(
            \.hasChevronButtonTapped,
             with: self(\.hasChevronButtonTapped)
             ? false
             : true
        )
    }
    
    public func onSpeechTransicriptionUpdated(_ str: String) {
        self.updateState(\.answeredText, with: str)
        self.updateState(\.hasGuidingMessageShown, with: true)
        HapticManager.sharedInstance.generateHaptic(.light(times: countLastWord(str)))
    }
    
    private func countLastWord(_ transcript: String) -> Int {
        return transcript.components(separatedBy: " ").last?.count ?? 0
    }
}

// MARK: Reduce
extension CommunicationViewStore {
    /// ViewState를 업데이트하는 keyPath 기반 메소드
    /// 일반적인 경우, default 만으로 대응이 가능하나, 특별한 로직이 필요할 경우 할당하는 로직을 케이스로 추가할 수 있다.
    /// - Parameters:
    ///   - state: 업데이트할 ViewState의 속성 전달
    ///   - newValue: 새로 업데이트할 ViweState의 값 전달
    private func updateState<Value: Equatable>(
        _ state: WritableKeyPath<CommunicationState, Value>,
        with newValue: Value
    ) {
        switch state {
        case \.historyItem:
            self.viewState[keyPath: state] = newValue
            if let newHistoryItem = self.viewState.historyItem {
                self.viewState.historyItems.append(newHistoryItem)
            }
        case \.hasGuidingMessageShown:
            withAnimation {
                self.viewState[keyPath: state] = newValue
            }
            
        case \.historyItems:
            break
            
        default:
            self.viewState[keyPath: state] = newValue
        }
    }
}
