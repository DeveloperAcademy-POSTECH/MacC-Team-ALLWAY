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

extension TKReducer where Self.ViewState: RootState & Equatable {
    func listen<Value: Equatable>
    (_ path: KeyPath<some ChildState, Value>) {
        
    }
}

extension TKReducer where Self.ViewState: ChildState & Equatable {
    func notify() {
        
    }
}

protocol TKAnimatable {
    var animationFlag: Bool { get set }
}

protocol ChildState: Equatable {
    // 자기 자신이 어떻게 변했는지 알려주는 didChange
    func didChange<Value: Equatable>(path: KeyPath<ChildReducer.ViewState, Value>) -> Value
}

protocol RootState: Equatable { }

/// Child의 변화를 Parent에 알려주는 Mediator
struct BDMediator {
    static func notified<ChildStore: TKReducer, Value: Equatable> (
        from child: ChildStore,
        path: KeyPath<some ChildState, Value>
    ) where ChildStore.ViewState: ChildState
    {
        
    }
}

///

// MARK: - USAGE EXAMPLE
final class ParentReducer<Delegate: TKReducer>: TKReducer {
    // 1. child가 있다면 delegate를 선언해준다.
    var delegate: Delegate!
    
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
    
    // 2. 자동으로 listen한다.
    func listen() {
        // 3. delegate에서 무엇이 변했는지 받아온다.
        
    }
}

final class ChildReducer: TKReducer {
    struct ViewState: ChildState, Equatable {
        
        var childName: String = "Child"
        func didChange<Value: Equatable>(path: KeyPath<ChildReducer.ViewState, Value>) -> Value {
            self[keyPath: path]
        }
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
        self.viewState.didChange(path: path)
    }
    
    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
        self.viewState[keyPath: path]
    }
}

struct ParentView: View {
    @StateObject private var store = ParentReducer<ChildReducer>()
    @StateObject private var childStore: ChildReducer = ChildReducer()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(store(\.parentName))
                
                NavigationLink {
                    ChildView(store: childStore)
                    
                } label: {
                    Text("Go child")
                }
            }
        }
    }
}

struct ChildView: View {
    @ObservedObject var store: ChildReducer
    
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

//extension View {
//    func listenTo(
//        child: ChildReducer,
//        reduce: @escaping (
//            _ oldValue: ChildReducer.ViewState,
//            _ newValue: ChildReducer.ViewState
//        ) -> Void
//    ) -> some View {
//        onChange(of: child.listenState) { oldValue, newValue in
//            reduce(oldValue, newValue)
//        }
//    }
//}
