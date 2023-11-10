//
//  TKMainViewStore.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

final class TKMainViewStore {
    struct ViewState: TKAnimatable {
        var animationFlag: Bool = false
        var isConversationFullScreenCoverDisplayed: Bool = false
        var isBottomSheetMaxed: Bool = false
        var offset: CGFloat = 0
        var lastOffset: CGFloat = 0
    }
    
    @Published var viewState: ViewState = ViewState()
    
    public func bindingConversationFullScreenCover() -> Binding<Bool> {
        Binding(
            get: { self(\.isConversationFullScreenCoverDisplayed) },
            set: { self.reduce(\.isConversationFullScreenCoverDisplayed, into: $0) }
        )
    }
    
    public func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
    
    public func onStartConversationButtonTapped() {
        reduce(\.isConversationFullScreenCoverDisplayed, into: true)
    }
    
    public func onBottomSheetMaxed(_ height: CGFloat) {
        let flag = height <= abs(self(\.lastOffset))
        reduce(\.isBottomSheetMaxed, into: flag)
    }
    
    public func onUpdatingDragOffset(_ gestureOffset: CGFloat) {
        Task { @MainActor in
            reduce(\.offset, into: gestureOffset + self(\.lastOffset))
        }
    }
    
    public func onDragEnded(_ maxHeight: CGFloat) {
        withAnimation(.spring()) {
            if -self(\.offset) > maxHeight / 2 {
                reduce(\.offset, into: -maxHeight)
            } else {
                reduce(\.offset, into: 0)
            }
        }
        reduce(\.lastOffset, into: self(\.offset))
    }
}

extension TKMainViewStore: TKReducer {
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value {
        self.viewState[keyPath: path]
    }
    
    func reduce<Value: Equatable>(
        _ path: WritableKeyPath<ViewState, Value>,
        into newValue: Value
    ) {
        viewState[keyPath: path] = newValue
    }
}
