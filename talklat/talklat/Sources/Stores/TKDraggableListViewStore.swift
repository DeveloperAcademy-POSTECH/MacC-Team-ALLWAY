//
//  TKRecentConversationListViewStore.swift
//  bisdam
//
//  Created by user on 11/23/23.
//

import Foundation
import SwiftUI

class TKDraggableListViewStore: TKReducer {
    struct ViewState {
        var isShowingConversationView: Bool = false
        var conversations: [TKConversation] = [TKConversation]()
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
        return self.viewState[keyPath: path]
    }
    
    func reduce<Value>(_ path: WritableKeyPath<ViewState, Value>, into newValue: Value) where Value : Equatable {
        self.viewState[keyPath: path] = newValue
    }
    
    
    public func bindingIsShowingConversationView() -> Binding<Bool> {
        return Binding(
            get: { self(\.isShowingConversationView) },
            set: { self.reduce(\.isShowingConversationView, into: $0) }
        )
    }
    
    public func onTapDraggableListItem(_ conversation: TKConversation) {
        self.reduce(\.isShowingConversationView, into: true)
    }
}
