//
//  SettingViewStore.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import Foundation
import SwiftUI

// TODO: Reducer 생성 및 연결
final class TextReplacementViewStore: TKReducer {
    
    struct ViewState: Equatable {
        var showingTextReplacementEditView: Bool = false
        var showingTextReplacementAddView: Bool = false
        
        var isDialogShowing: Bool = false
        
        var selectedPhrase: String = ""
        var selectedReplacement: String = ""
    }
    
    @Published var viewState: ViewState = ViewState()
    
    var selectedTextReplacement: TKTextReplacement? = nil
    
    init(viewState: ViewState) {
        self.viewState = viewState
    }
    
    // MARK: HELPERS
    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
        self.viewState[keyPath: path]
    }
    
    func reduce<Value>(_ path: WritableKeyPath<ViewState, Value>, into newValue: Value) where Value : Equatable {
        self.viewState[keyPath: path] = newValue
    }
    
    public func onShowDialogButtonTapped() {
        self.reduce(\.isDialogShowing, into: true)
    }
    
    func selectTextReplacement(phrase: String, replacement: String) {
        self.reduce(\.selectedPhrase, into: phrase)
        self.reduce(\.selectedReplacement, into: replacement)
        self.reduce(\.showingTextReplacementEditView, into: true)
    }
    
    func bindingPhraseTextField() -> Binding<String> {
        Binding(
            get: { self(\.selectedPhrase) },
            set: { self.reduce(\.selectedPhrase, into: $0) }
        )
    }
    
    func bindingReplacementTextField() -> Binding<String> {
        Binding(
            get: { self(\.selectedReplacement) },
            set: { self.reduce(\.selectedReplacement, into: $0) }
        )
    }
    
    func bindingReplacementRemoveAlert() -> Binding<Bool> {
        Binding(
            get: { self(\.isDialogShowing) },
            set: { self.reduce(\.isDialogShowing, into: $0) }
        )
        
    }
    
    func bindingToShowTextReplacementEditView() -> Binding<Bool> {
        return Binding<Bool>(
            get: { self.viewState.showingTextReplacementEditView },
            set: {
                self.viewState.showingTextReplacementEditView = $0
            }
        )
    }
    
    func bindingToShowTextReplacementAddView() -> Binding<Bool> {
        return Binding<Bool>(
            get: { self.viewState.showingTextReplacementAddView },
            set: {
                self.viewState.showingTextReplacementAddView = $0
            }
        )
    }
    
    func showTextReplacementAddView() {
        viewState.showingTextReplacementAddView = true
    }
}
