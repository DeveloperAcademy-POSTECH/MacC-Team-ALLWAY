//
//  SettingViewStore.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import Foundation
import SwiftUI

final class SettingViewStore: ObservableObject {
    struct SettingState: Equatable {
        var showingTextReplacementEditView: Bool = false
        var selectedPhrase: String? = nil
        var selectedReplacement: String? = nil
        var showingTextReplacementAddView: Bool = false
        var selectedTextReplacement: TKTextReplacement? = nil
    }
    
    @Published var viewState: SettingState
    var selectedTextReplacement: TKTextReplacement? = nil
    var selectedPhrase: String? = nil
    var selectedReplacement: String? = nil
    
    init(settingState: SettingState) {
        viewState = settingState
    }
    
    func selectTextReplacement(phrase: String, replacement: String) {
        print("Selecting text replacement: \(phrase) -> \(replacement)")
        viewState.selectedPhrase = phrase
        viewState.selectedReplacement = replacement
        viewState.showingTextReplacementEditView = true
        print("selectTextReplacement 후: selectedPhrase = \(String(describing: viewState.selectedPhrase)), selectedReplacement = \(String(describing: viewState.selectedReplacement))")
    }
    
    func bindingToShowTextReplacementEditView() -> Binding<Bool> {
        print("bindingToShowTextReplacementEditView 호출됨, 현재 상태: \(viewState.showingTextReplacementEditView)")
        return Binding<Bool>(
            get: { self.viewState.showingTextReplacementEditView },
            set: {
                print("showingTextReplacementEditView 변경됨: \($0)")
                self.viewState.showingTextReplacementEditView = $0
            }
        )
    }
    
    func bindingToShowTextReplacementAddView() -> Binding<Bool> {
        print("bindingToShowTextReplacementAddView 호출됨, 현재 상태: \(viewState.showingTextReplacementAddView)")
        return Binding<Bool>(
            get: { self.viewState.showingTextReplacementAddView },
            set: {
                print("showingTextReplacementAddView 변경됨: \($0)")
                self.viewState.showingTextReplacementAddView = $0
            }
        )
    }
    
    func showTextReplacementAddView() {
        print("showTextReplacementAddView 호출됨")
        viewState.showingTextReplacementAddView = true
    }
    
    func closeTextReplacementAddView() {
        print("closeTextReplacementAddView 호출됨")
        viewState.showingTextReplacementAddView = false
    }
}
