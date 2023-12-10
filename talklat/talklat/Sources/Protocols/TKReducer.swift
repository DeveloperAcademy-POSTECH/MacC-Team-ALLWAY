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
    associatedtype ViewState: Equatable
    
    func callAsFunction<Value: Equatable>
    (_ path: KeyPath<ViewState, Value>) -> Value
    
    func reduce<Value: Equatable>
    (_ path: WritableKeyPath<ViewState, Value>,
     into newValue: Value)
    
    func listen<Child: TKReducer, Value: Equatable>
    (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value)
}


extension TKReducer {
    // 진짜 이러기 싫다
    // 개망한 Open Close 는 이렇게 되는구나
    func listen<Child: TKReducer, Value: Equatable>
    (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) {
        
    }
}

extension TKReducer where Self.ViewState: TKAnimatable {
    func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
}

extension TKReducer {
    /// notify 메소드는 Child에서 호출한다.
    /// - Parameters:
    ///   - parent: 변경된 사항을 받기 위한 Parent
    ///   - path: 변경된 path를 전달
    ///   - value: 변경된 값을 전달
    func notify<Parent: TKReducer, Value: Equatable>
    (to parent: Parent, path: KeyPath<ViewState, Value>, value: Value) {
        parent.listen(to: self, path, value: value)
    }
}

protocol TKAnimatable: Equatable {
    var animationFlag: Bool { get set }
}

// MARK: - USAGE EXAMPLE
final class ParentReducer {
    struct ViewState: Equatable {
        var parentName: String = "Parent"
        var booo: Bool = false
    }
    
    @Published private var viewState: ViewState = ViewState()
}

extension ParentReducer: TKReducer {
    func listen<Child: TKReducer, Value: Equatable>
    (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) {
        typealias ChildState = ChildReducer.ViewState
        
        switch path {
        case \ChildState.childName:
            reduce(\.parentName, into: value as! String)
        case \ChildState.booleann:
            reduce(\.booo, into: value as! Bool)
        default:
            break
        }
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

final class ChildReducer: TKReducer {
    weak var parent: (any TKReducer)?
    
    struct ViewState: Equatable {
        var childName: String = "Child"
        var booleann: Bool = true
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func onUpdateName(with str: String) {
        reduce(\.childName, into: str)
        guard let parent else { return }
        notify(to: parent, path: \.childName, value: str)
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
                    ChildView(store: childStore)
                    
                } label: {
                    Text("Go child")
                }
            }
            .onAppear {
                if childStore.parent == nil {
                    childStore.parent = store
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
