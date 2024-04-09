//
//  CommunicationViewStore.swift
//  talklat
//
//  Created by Celan on 10/25/23.
//

import SwiftUI
import SwiftData

final class TKConversationViewStore {
    enum ConversationStatus: Equatable {
        case recording
        case guiding
        case writing
    }
    
    struct ConversationState: Equatable, TKAnimatable {
        var animationFlag: Bool = false
        
        var isConversationFullScreenDismissed: Bool = false
        var isConversationDismissAlertPresented: Bool = false
        
        var conversationStatus: ConversationStatus
        var questionText: String = ""
        var answeredText: String = ""
        var conversationTitle: String = NSLocalizedString("새로운 대화", comment: "")
        
        var hasGuidingMessageShown: Bool = false
        var hasSavingViewDisplayed: Bool = false
        var hasChevronButtonTapped: Bool = false
        var historyItems: [HistoryItem] = [
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .question, createdAt: .now),
//            .init(id: .init(), text: "(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠(난청인질문) 일이삼사오육칠팔구십일이삼사오육칠팔구십", type: .answer, createdAt: .now),
        ]
        var historyItem: HistoryItem?
        var blockButtonDoubleTap: Bool = false
        var isNewConversationSaved: Bool = false
        
        var currentConversationCount: Int = 0
        var allConversationTitles: [String] = []
        var hasCurrentConversationTitlePrevious: Bool = false
        
        // scroll container related - TODO: ScrollStore 분리?
        var historyScrollViewHeight: CGFloat = 0
        var historyScrollOffset: CGPoint = CGPoint(x: -0.0, y: 940.0)
        var deviceHeight: CGFloat = 0
        var topInset: CGFloat = 0
        var bottomInset: CGFloat = 0
        var isTopViewShown: Bool = false
        var isHistoryViewShownWithTransition: Bool = false
        var previousConversation: TKConversation? = nil
    }
    
    @Published private var viewState: ConversationState = ConversationState(conversationStatus: .writing)
    
    public let questionTextLimit: Int = 160
    public let conversationTitleLimit: Int = 20
    
    public var isAnswerCardDisplayable: Bool {
        if let recentHistoryItem = self(\.historyItem) {
            return recentHistoryItem.type == .answer && self(\.conversationStatus) == .writing
        } else {
            return false
        }
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
    
    public func bindingConversationTitle() -> Binding<String> {
        Binding(
            get: { self(\.conversationTitle) },
            set: {
                if $0.count > self.questionTextLimit {
                    self.reduce(
                        \.conversationTitle,
                         into: String($0.prefix(self.conversationTitleLimit))
                    )
                } else {
                    self.reduce(
                        \.conversationTitle,
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
    
    public func bindingTKAlertFlag() -> Binding<Bool> {
        Binding(
            get: { self(\.isConversationDismissAlertPresented) },
            set: { self.reduce(\.isConversationDismissAlertPresented, into: $0) }
        )
    }
}

extension TKConversationViewStore {
    public func resetConversationState() {
        let newViewState = ViewState(conversationStatus: .writing)
        self.reduce(\ViewState.self, into: newViewState)
    }
    
    public func onDeleteConversationTitleButtonTapped() {
        self.reduce(\.conversationTitle, into: "")
    }
    
    public func makeNewConversation<TKPersistentModel: PersistentModel>(
        with transcript: String,
        at location: TKLocation
    ) -> TKPersistentModel? {
        if self(\.previousConversation) == nil,
           self(\.allConversationTitles).contains(where: { str in
               self(\.conversationTitle) == str
           }) {
            reduce(
                \.hasCurrentConversationTitlePrevious,
                 into: true
            )
            
            return nil
        }
        
        onSpeechTranscriptUpdated(transcript)
        makeCurrentConversationContent()
        
        let newContents = self(\.historyItems)
            .map {
                TKContent(
                    text: $0.text,
                    type: $0.type == .answer ? .answer : .question,
                    createdAt: $0.createdAt
                )
            }
            .filter { $0.text != "" }
        
        let newConversation = TKConversation(
            title: self(\.conversationTitle),
            createdAt: Date(),
            content: newContents,
            location: location
        )
        
        return newConversation as? TKPersistentModel
    }
    
    public func makeCurrentConversationContent() {
        reduce(
            \.historyItem,
             into: HistoryItem(
                id: .init(),
                text: self(\.conversationStatus) == .recording
                ? self(\.answeredText)
                : self(\.questionText),
                type: self(\.conversationStatus) == .recording
                ? .answer
                : .question,
                createdAt: .init()
             )
        )
    }
    
    public func onTKHistoryPreviewAppeared() {
        if let previousConversation = self(\.previousConversation) {
            let previousHistory = previousConversation.content.map { content in
                return HistoryItem(
                    id: UUID(),
                    text: content.text,
                    type: content.type == .answer ? .answer : .question,
                    createdAt: content.createdAt
                )
            }
            
            reduce(\.historyItems, into: previousHistory)
        }
    }
    
    public func onConversationDismissButtonTapped() {
        withAnimation {
            reduce(\.isConversationDismissAlertPresented, into: true)
        }
    }
    
    public func onSaveConversationIntoPreviousButtonTapped() {
        reduce(\.isConversationFullScreenDismissed, into: true)
    }
    
    public func onSaveNewConversationButtonTapped() {
        withAnimation {
            reduce(
                \.isNewConversationSaved,
                 into: true
            )
        }
    }
    
    public func onSaveToPreviousButtonTapped(_ newContents: [TKContent]) {
        if let _ = self(\.previousConversation) {
            if var content = self(\.previousConversation)?.content {
                content.append(contentsOf: newContents)
            }
//            self(\.previousConversation)?.content.append(contentsOf: newContents)
        }
        
        withAnimation {
            reduce(
                \.isNewConversationSaved,
                 into: true
            )
        }
    }

    public func onBackToWritingChevronTapped() {
        withAnimation {
            switchConverstaionStatus()
        }
    }

    public func onTextReplaceButtonTapped(
        with replacement: String,
        key: String
    ) {
        let currentText = self(\.questionText)
        var words = currentText.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
        
        if let lastWord = words.last, lastWord.lowercased() == key.lowercased() {
            words[words.count - 1] = replacement
            let updatedText = words.joined(separator: " ")
            
            reduce(\.questionText, into: updatedText)
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
    
    public func onSaveConversationSheetAppear(
        _ conversations: [TKConversation]
    ) {
        reduce(
            \.allConversationTitles,
             into: conversations.map(\.title)
        )
        
        let currentConversationTitle = self(\.conversationTitle) + "(\(self(\.allConversationTitles).count.description))"
        
        reduce(
            \.conversationTitle,
             into: currentConversationTitle
        )
    }
    
    public func onSaveConversationButtonTapped() {
        reduce(
            \.hasSavingViewDisplayed,
             into: true
        )
    }
    
    public func onDismissSavingViewButtonTapped() {
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
                 into: HistoryItem(
                    id: .init(),
                    text: self(
                        \.questionText
                    ),
                    type: .question,
                    createdAt: .init()
                 )
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
                 into: HistoryItem(
                    id: .init(),
                    text: self(\.answeredText),
                    type: .answer,
                    createdAt: Date()
                 )
            )
        }
        
        withAnimation {
            reduce(\.answeredText, into: "")
            switchConverstaionStatus()
        }
        
        HapticManager.sharedInstance.generateHaptic(.rigidTwice)
    }
    
    @available(*, deprecated, renamed: "onPreviewChevronButton", message: "use onPreviewChevronButtonTapped")
    public func onChevronButtonTapped() {
        reduce(
            \.hasChevronButtonTapped,
             into: !self(\.hasChevronButtonTapped)
        )
    }
    
    public func onShowPreviewChevronButtonTapped() {
        withAnimation {
            reduce(\.isTopViewShown, into: true)
        }
    }
    
    public func onDismissPreviewChevronButtonTapped() {
        withAnimation(.bouncy(duration: 1.0)) {
            reduce(\.isTopViewShown, into: false)
        }
    }
    
    @MainActor
    public func getTKContentFromHistory() async -> [TKContent] {
        return self(\.historyItems).map {
            TKContent(
                text: $0.text,
                type: $0.type == .answer ? .answer : .question,
                createdAt: $0.createdAt
            )
        }
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
            switchConverstaionStatus()
        }
        
        HapticManager.sharedInstance.generateHaptic(.success)
    }
    
    public func onShowingQuestionCancelButtonTapped() {
        withAnimation {
            reduce(\.conversationStatus, into: .writing)
        }
    }
    
    public func onSpeechTranscriptUpdated(_ str: String) {
        reduce(\.answeredText, into: str)
        HapticManager.sharedInstance.generateHaptic(.light(times: countLastWord(str)))
    }
}

extension TKConversationViewStore {
    public func isTextFieldEmpty() -> Bool {
        switch self(\.conversationStatus) {
        case .writing:
            return self(\.questionText).isEmpty
        case .recording:
            return self(\.answeredText).isEmpty
        default:
            return true // For other statuses, handle as required
        }
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
            if let newHistoryItem = self(\.historyItem) {
                self.viewState.historyItems.append(newHistoryItem)
            }
            
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
            defer { reduce(\.hasGuidingMessageShown, into: true) }
            if !self(\.hasGuidingMessageShown) && UserDefaults.standard.bool(forKey: "isGuidingEnabled") {
                reduce(\.conversationStatus, into: .guiding)
            } else if self(\.hasGuidingMessageShown) || !UserDefaults.standard.bool(forKey: "isGuidingEnabled") {
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
