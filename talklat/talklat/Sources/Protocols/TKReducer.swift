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
protocol TKReducer<ViewState>: AnyObject, ObservableObject {
    associatedtype ViewState
    
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value
    
    func reduce<Value: Equatable>
    (_ path: WritableKeyPath<ViewState, Value>,
     into newValue: Value)
}

extension TKReducer where Self.ViewState: TKAnimatable {
    func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
}

extension TKReducer where Self.ViewState: ChildState & Equatable {
    var listenState: Self.ViewState {
        self(\ViewState.self)
    }
}

extension TKReducer where Self.ViewState: ChildState & Equatable {
    func comprehenseChild() {
        
    }
}

protocol TKAnimatable {
    var animationFlag: Bool { get set }
}

protocol ChildState: Equatable { }
protocol ParentState: Equatable { }

extension View {
    func listenTo(
        child: ChildReducer,
        reduce: @escaping (
            _ oldValue: ChildReducer.ViewState,
            _ newValue: ChildReducer.ViewState
        ) -> Void
    ) -> some View {
        onChange(of: child.listenState) { oldValue, newValue in
            reduce(oldValue, newValue)
        }
    }
}

///

final class BDMediator {
    func notify(
        from: some TKReducer,
        to: some TKReducer
    ) {
        
    }
}

///

// MARK: - USAGE EXAMPLE
final class ParentReducer: TKReducer {
    struct ViewState {
        var parentName: String = "Parent"
    }
    
    @Published private var viewState: ViewState = ViewState()
        
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

final class ChildReducer: TKReducer {
    struct ViewState: ChildState, Equatable {
        var childName: String = "Child"
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func onUpdateName(with str: String) {
        reduce(\.childName, into: str)
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

struct ParentView: View {
    @StateObject private var store = ParentReducer()
    @StateObject private var childStore: ChildReducer = ChildReducer()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(store(\.parentName))
                
                NavigationLink {
                    ChildView()
                    
                } label: {
                    Text("Go child")
                }
            }
            .listenTo(child: childStore) { oldValue, newValue in
                
            }
        }
    }
}

struct ChildView: View {
    @StateObject private var store = ChildReducer()
    
    var body: some View {
        VStack {
            Text(store(\.childName))
            
            Button {
                store.onUpdateName(with: "Updated Name")
            } label: {
                Text("Update")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParentView()
    }
}
