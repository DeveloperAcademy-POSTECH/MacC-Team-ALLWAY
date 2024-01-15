//
//  TextReplacementViewStore.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import Foundation
import SwiftUI
import SwiftData

final class TextReplacementViewStore: TKReducer {
    
    struct ViewState: Equatable {
        var showingTextReplacementEditView: Bool = false
        var showingTextReplacementAddView: Bool = false
        
        var isDialogShowing: Bool = false
        var isSearching: Bool = false
        var searchText: String = ""
        
        var selectedPhrase: String = ""
        var selectedReplacement: String = ""
        
        var originalPhrase: String = ""
        var originalReplacement: String = ""
        
//        var selectedTextReplacement: TKTextReplacement? = nil
    }
    
    @Published var viewState: ViewState = ViewState()
    
    var isSaveButtonDisabled: Bool {
        self(\.selectedPhrase).isEmpty || self(\.selectedReplacement).isEmpty ||
        (self(\.originalPhrase) == self(\.selectedPhrase) && self(\.originalReplacement) == self(\.selectedReplacement))
    }
    
    // MARK: - HELPERS
    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
        self.viewState[keyPath: path]
    }
    
    func reduce<Value>(_ path: WritableKeyPath<ViewState, Value>, into newValue: Value) where Value : Equatable {
        self.viewState[keyPath: path] = newValue
    }
    
    // MARK: - View용 함수
    // 기본 Create
    public func createTextReplacement<TKPersistentModel: PersistentModel>(
        phrase: String,
        replacement: String
    ) -> TKPersistentModel? {
        let newTextReplacement = TKTextReplacement(
            wordDictionary: [phrase: [replacement]]
        )
        
        return newTextReplacement as? TKPersistentModel
    }
    
    public func bindingSearchText() -> Binding<String> {
        Binding(
            get: { self(\.searchText) },
            set: { self.reduce(\.searchText, into: $0) }
        )
    }
    
    public func bindingShowTKAlert() -> Binding<Bool> {
        Binding(
            get: { self(\.isDialogShowing) },
            set: { self.reduce(\.isDialogShowing, into: $0) }
        )
    }
    
    public func onDismissRemoveAlert() {
        self.reduce(\.isDialogShowing, into: false)
    }
    
    public func onSearchTextRemoveButtonTapped() {
        self.reduce(\.searchText, into: "")
    }
    
    public func onSearchingText() {
        self.reduce(\.isSearching, into: true)
    }
    
    public func onCancelSearch() {
        self.reduce(\.isSearching, into: false)
        self.reduce(\.searchText, into: "")
    }
    
    public func onShowDialogButtonTapped() {
        withAnimation {
            self.reduce(\.isDialogShowing, into: true)
        }
    }
    
    func selectTextReplacement(phrase: String, replacement: String) {
        self.reduce(\.selectedPhrase, into: phrase)
        self.reduce(\.selectedReplacement, into: replacement)
        self.reduce(\.showingTextReplacementEditView, into: true)
        self.reduce(\.originalPhrase, into: phrase)
        self.reduce(\.originalReplacement, into: replacement)
    }
    
    func cancelSearchAndHideKeyboard() {
        self.reduce(\.isSearching, into: false)
        self.reduce(\.searchText, into: "")
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

