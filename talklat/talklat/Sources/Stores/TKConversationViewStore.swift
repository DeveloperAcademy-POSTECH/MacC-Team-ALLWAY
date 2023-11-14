//
//  CommunicationViewStore.swift
//  talklat
//
//  Created by Celan on 10/25/23.
//

import SwiftUI

final class TKConversationViewStore {
    enum ConversationStatus: Equatable {
        case recording
        case guiding
        case writing
    }
    
    struct ConversationState: Equatable {
        var conversationStatus: ConversationStatus
        var questionText: String = ""
        var answeredText: String = ""
        var hasGuidingMessageShown: Bool = false
        var hasSavingViewDisplayed: Bool = false
        var hasChevronButtonTapped: Bool = false
        var historyItems: [HistoryItem] = []
        var historyItem: HistoryItem?
        var blockButtonDoubleTap: Bool = false
        var isNewConversationSaved: Bool = false
        
        // scroll container related - TODO: ScrollStore 분리?
        var historyScrollViewHeight: CGFloat = 0
        var historyScrollOffset: CGPoint = CGPoint(x: -0.0, y: 940.0)
        var deviceHeight: CGFloat = 0
        var topInset: CGFloat = 0
        var bottomInset: CGFloat = 0
        var isTopViewShown: Bool = false
        var isHistoryViewShownWithTransition: Bool = false
    }
    
    @Published private var viewState: ConversationState = ConversationState(conversationStatus: .writing)
    
    public let questionTextLimit: Int = 160
    public var isAnswerCardDisplayable: Bool {
        !self(\.historyItems).isEmpty && self(\.conversationStatus) == .writing
    }
    
    // MARK: Helpers
    public func bindingQuestionText() -> Binding<String> {
        Binding(
            get: { self(\.questionText) },
            set: {
                if $0.count > self.questionTextLimit {
                    self.reduce(
                        \.questionText,
                         into: String($0.prefix(self.questionTextLimit))
                    )
                } else {
                    self.reduce(
                        \.questionText,
                         into: $0
                    )
                }
            }
        )
    }
    
    public func bindingHistoryScrollOffset() -> Binding<CGPoint> {
        Binding(
            get: { self(\.historyScrollOffset) },
            set: { _ in }
        )
    }
    
    public func bindingSaveConversationViewFlag() -> Binding<Bool> {
        Binding(
            get: { self(\.hasSavingViewDisplayed) },
            set: { _ in }
        )
    }
    
    public func bindingNewConversationToast() -> Binding<Bool> {
        Binding(
            get: { self(\.isNewConversationSaved) },
            set: { self.reduce(\.isNewConversationSaved, into: $0) }
        )
    }
}

extension TKConversationViewStore {
    public func onSaveNewConversationButtonTapped() {
        withAnimation {
            reduce(\.isNewConversationSaved, into: true)
        }
    }

    public func onBackToWritingChevronTapped() {
        withAnimation {
            switchConverstaionStatus()
        }
    }
    
    public func blockButtonDoubleTap(completion: () -> Void) {
        defer {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.75))
                reduce(\.blockButtonDoubleTap, into: false)
            }
        }
        reduce(\.blockButtonDoubleTap, into: true)
        completion()
    }
    
    public func onSaveConversationButtonTapped() {
        reduce(
            \.hasSavingViewDisplayed,
             into: true
        )
    }
    
    public func onDismissConversationButtonTapped() {
        reduce(
            \.hasSavingViewDisplayed,
             into: false
        )
    }
    
    public func onScrollContainerAppear(
        geo: GeometryProxy,
        insets: UIEdgeInsets
    ) {
        reduce(\.deviceHeight, into: geo.size.height)
        reduce(\.topInset, into: insets.top)
        reduce(\.bottomInset, into: insets.bottom)
    }
    
    public func onHistoryViewAppear(geo: GeometryProxy) {
        reduce(\.historyScrollViewHeight, into: geo.size.height)
    }
    
    public func onStartRecordingButtonTapped() {
        withAnimation {
            switchConverstaionStatus()
        }
        
        if !self(\.questionText).isEmpty {
            reduce(
                \.historyItem,
                 into: HistoryItem(id: .init(), text: self(\.questionText), type: .question)
            )
        }
        
        HapticManager.sharedInstance.generateHaptic(.success)
    }
    
    public func onEraseAllButtonTapped() {
        reduce(\.questionText, into: "")
    }
    
    public func onStopRecordingButtonTapped() {
        reduce(\.questionText, into: "")
        
        if !self(\.answeredText).isEmpty {
            reduce(
                \.historyItem,
                 into: HistoryItem(id: .init(), text: self(\.answeredText), type: .answer)
            )
        }
        
        withAnimation {
            reduce(\.answeredText, into: "")
            switchConverstaionStatus()
        }
        
        HapticManager.sharedInstance.generateHaptic(.rigidTwice)
    }
    
    public func onChevronButtonTapped() {
        reduce(
            \.hasChevronButtonTapped,
             into: self(\.hasChevronButtonTapped)
             ? false
             : true
        )
    }
    
    public func onScrollOffsetChanged(_ value: Bool) {
        withAnimation(
            .spring(
                response: 0.5,
                dampingFraction: 0.7
            )
            .speed(0.7)
        ) {
            reduce(\.isTopViewShown, into: value)
        }
        
        withAnimation(.easeIn.speed(0.2)) {
            reduce(\.isHistoryViewShownWithTransition, into: value)
        }
    }
    
    public func onGuideCancelButtonTapped() {
        withAnimation {
            reduce(\.conversationStatus, into: .writing)
        }
    }
    
    public func onGuideTimeEnded() {
        withAnimation {
            reduce(\.conversationStatus, into: .recording)
        }
        
        HapticManager.sharedInstance.generateHaptic(.success)
    }
    
    public func onShowingQuestionCancelButtonTapped() {
        withAnimation {
            reduce(\.conversationStatus, into: .writing)
        }
    }
    
    public func onSpeechTransicriptionUpdated(_ str: String) {
        reduce(\.answeredText, into: str)
        HapticManager.sharedInstance.generateHaptic(.light(times: countLastWord(str)))
    }
}

// MARK: Reduce
extension TKConversationViewStore: TKReducer {
    /// ViewState를 업데이트하는 keyPath 기반 메소드
    /// 일반적인 경우, protocol의 기본 구현으로 대응할 수 있다.
    /// 특별한 로직이 필요할 경우 할당하는 로직을 케이스로 추가하기 위해 reduce를 직접 구현한다.
    /// public 호출이 가능하다.
    /// - Parameters:
    ///   - state: 업데이트할 ViewState의 경로 전달
    ///   - newValue: 새로 업데이트할 ViweState의 값 전달
    internal func reduce<Value: Equatable>(
        _ path: WritableKeyPath<ConversationState, Value>,
        into newValue: Value
    ) {
        switch path {
        case \.historyItem:
            self.viewState[keyPath: path] = newValue
            if let newHistoryItem = self.viewState.historyItem {
                self.viewState.historyItems.append(newHistoryItem)
            }
            
        case \.historyItems:
            break
            
        default:
            self.viewState[keyPath: path] = newValue
        }
    }
    
    func callAsFunction<Value>(_ path: KeyPath<ConversationState, Value>) -> Value where Value : Equatable {
        self.viewState[keyPath: path]
    }
}

// MARK: Helper
extension TKConversationViewStore {
    private func switchConverstaionStatus() {
        switch self(\.conversationStatus) {
        case .writing:
            if !self(\.hasGuidingMessageShown) {
                reduce(\.conversationStatus, into: .guiding)
                reduce(\.hasGuidingMessageShown, into: true)
                
            } else {
                reduce(\.conversationStatus, into: .recording)
            }
        
        case .guiding:
            reduce(\.conversationStatus, into: .recording)
            
        case .recording:
            reduce(\.conversationStatus, into: .writing)
        }
    }
    
    private func countLastWord(_ transcript: String) -> Int {
        return transcript.components(separatedBy: " ").last?.count ?? 0
    }
}
