//
//  TKStateReducer.swift
//  talklat
//
//  Created by Celan on 11/7/23.
//

import SwiftUI

/// ObservableObject를 채택하는 TKReducer 프로토콜
///
/// ViewState 타입 구조체, ``reduce(_:into:)`` 구현을 요구
/// store 역할을 수행할 class 타입에서 채택
protocol TKReducer: ObservableObject, AnyObject {
    associatedtype ViewState
    
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value
    
    func reduce<Value: Equatable>
    (_ path: WritableKeyPath<ViewState, Value>,
     into newValue: Value)
}

// MARK: - USAGE EXAMPLE
final class MyStore: TKReducer {
    struct ViewState {
        var name: String = ""
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func onUpdateName(with str: String) {
        reduce(\.name, into: str)
    }
    
    func reduce<Value: Equatable>(
        _ path: WritableKeyPath<ViewState, Value>,
        into newValue: Value)
    {
        self.viewState[keyPath: path] = newValue
    }
    
    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
        self.viewState[keyPath: path]
    }
}

struct MyStruct {
    @StateObject private var store = MyStore()
    
    func getName() -> String {
        store(\.name)
    }
    
    func updateName() {
        store.onUpdateName(with: "NewName")
    }
}
