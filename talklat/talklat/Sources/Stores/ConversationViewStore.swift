//
//  CommunicationViewStore.swift
//  talklat
//
//  Created by Celan on 10/25/23.
//

import SwiftUI

final class ConversationViewStore {
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
        var hasChevronButtonTapped: Bool = false
        var historyItems: [HistoryItem] = []
        var historyItem: HistoryItem?
        
        // scroll container related - TODO: ScrollStore 분리?
        var historyScrollViewHeight: CGFloat = CGFloat(0)
        var historyScrollOffset: CGPoint = CGPoint(x: -0.0, y: 940.0)
        var deviceHeight: CGFloat = 0
        var topInset: CGFloat = 0
        var bottomInset: CGFloat = 0
        var isTopViewShown: Bool = false
    }
    
    @Published private var viewState: ConversationState
    public let questionTextLimit: Int = 160
    public var isChevronButtonDisplayable: Bool {
        !self(\.historyItems).isEmpty && self(\.conversationStatus) == .writing
    }
    
    // MARK: init
    init(conversationState: ConversationState) {
        viewState = conversationState
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
            set: { _ in self(\.historyScrollOffset) }
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
    
    public func onWritingViewAppear() {
        switchConverstaionStatus()
        reduce(\.questionText, into: "")
        reduce(
            \.historyItem,
             into: HistoryItem(id: .init(), text: self(\.answeredText), type: .answer)
        )
        
        HapticManager.sharedInstance.generateHaptic(.rigidTwice)
    }
    
    @available(*, deprecated, renamed: "onStartRecordingButtonTapepd", message: "TKRecordingView Deprecated")
    public func onRecordingViewAppear() {
        switchConverstaionStatus()
        reduce(\.answeredText, into: "")
        if !self(\.questionText).isEmpty {
            reduce(
                \.historyItem,
                 into: HistoryItem(id: .init(), text: self(\.questionText), type: .question)
            )
        }
        
        HapticManager.sharedInstance.generateHaptic(.success)
    }
    
    public func onStartRecordingButtonTapped() {
        switchConverstaionStatus()
        reduce(\.answeredText, into: "")
        
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
        switchConverstaionStatus()
        reduce(\.questionText, into: "")
        
        if !self(\.answeredText).isEmpty {
            reduce(
                \.historyItem,
                 into: HistoryItem(id: .init(), text: self(\.answeredText), type: .answer)
            )
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
        reduce(\.isTopViewShown, into: value)
    }
    
    public func onGuideCancelButtonTapped() {
        reduce(\.conversationStatus, into: .writing)
    }
    
    public func onGuideTimeEnded() {
        reduce(\.conversationStatus, into: .recording)
    }
    
    public func onShowingQuestionCancelButtonTapped() {
        reduce(\.conversationStatus, into: .writing)
    }
    
    public func onSpeechTransicriptionUpdated(_ str: String) {
        reduce(\.answeredText, into: str)
        HapticManager.sharedInstance.generateHaptic(.light(times: countLastWord(str)))
    }
}

// MARK: Reduce
extension ConversationViewStore: TKReducer {
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
}

// MARK: Helper
extension ConversationViewStore {
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
