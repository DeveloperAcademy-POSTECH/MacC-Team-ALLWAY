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

protocol ReduceDelegate<Reducer> {
    associatedtype Reducer: TKReducer
    
    func listen(to: Reducer)
    
    func notify(to: Reducer)
}

extension TKReducer where Self.ViewState: TKAnimatable {
    func triggerAnimation(_ flag: Bool) {
        self.reduce(\.animationFlag, into: flag)
    }
}

protocol RootState: Equatable { }

protocol TKAnimatable {
    var animationFlag: Bool { get set }
}

// Parent의 delegate 를 child가 self로 받아와서 일을 한다.
// child는 자기 자신의 로직을 수행한 후, 필요할 때 delegate의 메소드를 호출하여 Parent에 변화를 알린다.

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
    struct ViewState {
        var childName: String = "Child"
    }
    
    @Published private var viewState: ViewState = ViewState()
    
    func onUpdateName(with str: String) {
        reduce(\.childName, into: str)
//        guard let parent else { return }
        
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
    
    func notify<Value: Equatable>
    (path: KeyPath<ViewState, Value>) {
        
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
