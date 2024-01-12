import SwiftUI

/// ObservableObject를 채택하는 TKReducer 프로토콜
///
/// ViewState 타입 구조체, ``reduce(_:into:)``, ``callAsFunction(_:)``, ``listen(to:_:value:)-1g4fr`` 구현을 요구
/// store 역할을 수행할 class 타입에서 채택
protocol TKReducer<ViewState>: AnyObject, ObservableObject {
  associatedtype ViewState: Equatable
  
  func callAsFunction<Value: Equatable>
  (_ path: KeyPath<ViewState, Value>) -> Value
  
  func reduce<Value: Equatable>
  (_ path: WritableKeyPath<ViewState, Value>,
   into newValue: Value)
  
  /// Parent Store에서 Child Store의 ViewState 변화를 받아올 때 호출하는 메소드 입니다.
  /// Child Store가 없다면 return 합니다.
  /// Child Store가 있다면 Child Store의 ViewState 타입을 지정하고 변화를 들을 path Switch case로 추가합니다.
  ///
  /// ``listen(to:_:value:)-1g4fr`` 는 추상화 Chlid 타입과 Equatable한 Value 타입을 갖습니다. Child의 ViewState를 받아와서 switch 하면
  /// 해당 변화에 따라 Parent Store가 추가적인 로직을 처리합니다.
  /// 예시는 아래와 같습니다.
  /// ```swift
  /// func listen<Child: TKReducer, Value: Equatable>
  /// (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) {
  ///    typealias ChildState = ChildReducer.ViewState
  ///
  ///    switch path {
  ///    case \ChildState.childName:
  ///      reduce(\.parentName, into: value as! String)
  ///    case \ChildState.childFlag:
  ///      reduce(\.parentFlag, into: value as! Bool)
  ///    default:
  ///      break
  ///    }
  ///  }
  /// ```
  ///
  /// - Parameters:
  ///   - to: Parent가 들을 Child Store. TKReducer의 확장에서 호출하는 Child Store의 인스턴스 기본 할당
  ///   - path: Child의 KeyPath. TKReducer의 확장에서 호출하는 Child Store의 ViewState KeyPath 기본 할당
  ///   - value: Child의 newValue. TKReducer의 확장에서 호출하는 Child Store의 newValue 기본 할당
  ///
  /// - Important: listen의 switch 구문에서 Value와 ViewState의 타입 연관성이 사라져 있음. 추후 개선이 가능한지 조사 필요
  func listen<Child: TKReducer, Value: Equatable>
  (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value)
}

extension TKReducer {
  func listen<Child: TKReducer, Value: Equatable>
  (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) { return }
}

extension TKReducer where Self.ViewState: TKAnimatable {
  func triggerAnimation(_ flag: Bool) {
    self.reduce(\.animationFlag, into: flag)
  }
}

extension TKReducer {
  /// ``notify(to:path:value:)``는 Child Store에서 호출합니다.
  /// Parent Store에 자기 자신의 속성이 변경된 경로와 함께 값을 전달합니다.
  /// Parent ViewState와 Child ViewState 사이의 reduce 순서를 임의로 설정할 수 있습니다.
  /// - Parameters:
  ///   - parent: Child의 변경된 사항을 받기 위한 Parent
  ///   - path: Child에서 변경된 path를 전달
  ///   - value: Child에서 변경된 값을 전달
  func notify<Parent: TKReducer, Value: Equatable>
  (to parent: Parent, path: KeyPath<ViewState, Value>, value: Value) {
    parent.listen(to: self, path, value: value)
  }
}

protocol TKAnimatable: Equatable {
  var animationFlag: Bool { get set }
}

// MARK: - USAGE EXAMPLE
fileprivate final class ParentReducer {
  struct ViewState: Equatable {
    var parentName: String = "Parent"
    var parentFlag: Bool = false
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
    case \ChildState.childFlag:
      reduce(\.parentFlag, into: value as! Bool)
    default:
      break
    }
  }
  
  func reduce<Value: Equatable>(
    _ path: WritableKeyPath<ViewState, Value>,
    into newValue: Value) {
    self.viewState[keyPath: path] = newValue
  }
  
  func callAsFunction<Value: Equatable>(_ path: KeyPath<ViewState, Value>) -> Value {
    self.viewState[keyPath: path]
  }
}

fileprivate final class ChildReducer: TKReducer {
  weak var parent: (any TKReducer)?
  
  struct ViewState: Equatable {
    var childName: String = "Child"
    var childFlag: Bool = true
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
  
  func callAsFunction<Value: Equatable>(_ path: KeyPath<ViewState, Value>) -> Value {
    self.viewState[keyPath: path]
  }
  
  func listen<Child: TKReducer, Value: Equatable>
  (to: Child, _ path: KeyPath<Child.ViewState, Value>, value: Value) { return }
}

fileprivate struct ParentView: View {
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

fileprivate struct ChildView: View {
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
