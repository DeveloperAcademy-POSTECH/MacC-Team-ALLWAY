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
        var isSpeechAuthAlertPresented: Bool = false
        var isTKToastPresented: Bool = false
        var isTKMainViewAppeared: Bool = false
        
        var offset: CGFloat = 0
        var lastOffset: CGFloat = 0
        var authStatus: AuthStatus = .splash
    }
    
    @Published var viewState: ViewState = ViewState()
    
    public func bindingConversationFullScreenCover() -> Binding<Bool> {
        Binding(
            get: { self(\.isConversationFullScreenCoverDisplayed) },
            set: { self.reduce(\.isConversationFullScreenCoverDisplayed, into: $0) }
        )
    }
    
    public func bindingTKToast() -> Binding<Bool> {
        Binding(
            get: { self(\.isTKToastPresented) },
            set: { self.reduce(\.isTKToastPresented, into: $0) }
        )
    }
    
    public func bindingSpeechAuthAlert() -> Binding<Bool> {
        Binding(
            get: { self(\.isSpeechAuthAlertPresented) },
            set: { self.reduce(\.isSpeechAuthAlertPresented, into: $0) }
        )
    }
    
    public func onConversationFullscreenDismissed() {
        reduce(\.isConversationFullScreenCoverDisplayed, into: false)
    }
    
    @MainActor
    public func onTKMainViewAppeared() async {
        try? await Task.sleep(for: .seconds(0.5))
        withAnimation {
            reduce(\.isTKMainViewAppeared, into: true)
        }
    }
    
    public func onNewConversationHasSaved() {
        self.reduce(
            \.isConversationFullScreenCoverDisplayed,
             into: false
        )
        withAnimation {
            self.reduce(
                \.isTKToastPresented,
                 into: true
            )
        }
    }
    
    public func onChangeOfSpeechAuth(_ authorized: Bool) {
        if authorized {
            self.reduce(\.isSpeechAuthAlertPresented, into: false)
            
        } else {
            self.reduce(\.isSpeechAuthAlertPresented, into: true)
        }
    }
    
    public func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
    
    public func onStartConversationButtonTappedWithoutAuth() {
        withAnimation {
            self.reduce(\.isSpeechAuthAlertPresented, into: true)
        }
    }
    
    public func onGoSettingScreenButtonTapped() {
        if let url = URL(
            string: UIApplication.openSettingsURLString
        ) {
            UIApplication.shared.open(url)
        }
    }
    
    public func onStartConversationButtonTapped() {
        reduce(\.isConversationFullScreenCoverDisplayed, into: true)
    }
    
    public func onBottomSheetMaxed(_ height: CGFloat) {
        let flag = height <= abs(self(\.lastOffset))
        reduce(\.isBottomSheetMaxed, into: flag)
    }
    
    public func onUpdatingDragOffset(_ height: CGFloat) {
        withAnimation(.spring()) {
            self.reduce(\.offset, into: height)
        }
    }
    
    public func onDragEnded(_ height: CGFloat) {
        withAnimation(.spring()) {
            if self(\.offset) < -150 {
                self.reduce(\.lastOffset, into: -(height))
                
            } else if self(\.lastOffset) != 0, self(\.offset) > 10 {
                self.reduce(\.lastOffset, into: .zero)
            }
            
            self.reduce(\.offset, into: 0)
        }
    }
    
    public func onVoiceAuthorizationObtained(_ status: AuthStatus) {
        reduce(\.authStatus,into: status)
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
