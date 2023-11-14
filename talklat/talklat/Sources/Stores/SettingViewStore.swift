//
//  SettingViewStore.swift
//  talklat
//
//  Created by 신정연 on 11/12/23.
//

import Foundation
import SwiftUI

// TODO: Reducer 생성 및 연결
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
        viewState.selectedPhrase = phrase
        viewState.selectedReplacement = replacement
        viewState.showingTextReplacementEditView = true
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
