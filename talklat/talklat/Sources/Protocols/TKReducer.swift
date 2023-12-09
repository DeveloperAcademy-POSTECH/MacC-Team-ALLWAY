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
}

extension TKReducer {
    // child가 notify하고 parent가 reduce 한다.
    func notify<Parent: TKReducer, Value: Equatable>
    (to parent: Parent, path: WritableKeyPath<Parent.ViewState, Value>, into value: Value) {
        parent.reduce(path, into: value)
    }
}

extension TKReducer where Self.ViewState: TKAnimatable {
    func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
}

protocol TKAnimatable: Equatable {
    var animationFlag: Bool { get set }
}

// MARK: - USAGE EXAMPLE
final class ParentReducer: TKReducer {
    struct ViewState: Equatable {
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
    var parent: (any TKReducer)?
    
    struct ViewState: Equatable {
        var childName: String = "Child"
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func onUpdateName(with str: String) {
        reduce(\.childName, into: str)
        guard let parent = parent as? ParentReducer else { return }
        notify(to: parent, path: \.parentName, into: str)
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
