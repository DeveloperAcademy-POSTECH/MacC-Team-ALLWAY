//
//  TKRecentConversationListViewStore.swift
//  bisdam
//
//  Created by user on 11/23/23.
//

import Foundation
import SwiftUI

final class TKDraggableListViewStore {
    struct ViewState: Equatable {
        var isShowingConversationView: Bool = false
        var conversations: [TKConversation] = [TKConversation]()
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    public func bindingIsShowingConversationView() -> Binding<Bool> {
        return Binding(
            get: { self(\.isShowingConversationView) },
            set: { self.reduce(\.isShowingConversationView, into: $0) }
        )
    }
    
    public func onConversationFullScreenDismissed() {
        reduce(\.isShowingConversationView, into: false)
    }
    
    public func onTapDraggableListItem(_ conversation: TKConversation) {
        self.reduce(\.isShowingConversationView, into: true)
    }
}

extension TKDraggableListViewStore: TKReducer {
    func callAsFunction<Value: Equatable> (_ path: KeyPath<ViewState, Value>) -> Value {
        self.viewState[keyPath: path]
    }
    
    func reduce<Value: Equatable>(_ path: WritableKeyPath<ViewState, Value>,
                                  into newValue: Value) {
        self.viewState[keyPath: path] = newValue
    }
    
    func listen<Child: TKReducer, Value: Equatable>
    (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) {
        
    }
}
