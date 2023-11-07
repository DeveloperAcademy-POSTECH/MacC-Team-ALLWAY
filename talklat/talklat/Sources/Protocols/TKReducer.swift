//
//  TKStateReducer.swift
//  talklat
//
//  Created by Celan on 11/7/23.
//

import SwiftUI

/// ObservableObject를 채택하는 프로토콜
/// 채택할 때, ViewState 타입인 구조체를 생성해야 하며
/// 해당 구조체를 reduce 할 로직을 직접 구현해야 한다.
/// 추가 로직이 불필요할 경우, ``self[keyPath: path] = newValue`` 한 줄로 갈음할 수 있다.
protocol TKReducer: ObservableObject, AnyObject {
    associatedtype ViewState
    
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value
    
    func reduce<Value: Equatable>
    (_ path: WritableKeyPath<ViewState, Value>,
     into newValue: Value)
}

extension TKReducer {
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value {
        self.callAsFunction(path)
    }
    
    func reduce<Value: Equatable>
    (_ path: WritableKeyPath<ViewState, Value>,
     into newValue: Value) {
        self.reduce(path, into: newValue)
    }
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
