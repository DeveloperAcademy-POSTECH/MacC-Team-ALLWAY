//
//  FirebaseAnalyzable.swift
//  bisdam
//
//  Created by user on 3/6/24.
//

import FirebaseAnalytics
import Foundation
import SwiftUI


protocol FirebaseAnalyzable {
    var firebaseStore: any TKFirebaseStore { get }
    
//    func firebaseAction(
//        _ eventName: String,
//        payload: [String: Any]?
//    )
}

//extension FirebaseAnalyzable {
//    func firebaseAction(
//        _ eventName: String = #function,
//        payload: [String: Any]? = nil
//    ) {
//        let obejctName: String = String(describing: type(of: self))
//        
//        firebaseStore.action(
//            obejctName,
//            eventName,
//            payload
//        )
//    }
//}



// Example Code
//struct ExampleFirebaseStore: TKFirebaseStore {
//    // 1. enum에 등록
//    enum FirebaseAction: String, FirebaseActionable {
//        
//        
//        case onPressed = "OnPressedRawValue"
//        case onCancelPressed = "OnCancelPressedRawValue"
//        case onEditPressed = "OnEditPressedRawValue"
//        case unRegistered
//        
//        static func create(_ eventName: String) -> Self {
//            switch eventName {
//            case "onPressed":
//                return .onPressed
//            case "onCancelPressed":
//                return .onCancelPressed
//            case "onEditPressed":
//                return .onEditPressed
//            default:
//                return .unRegistered
//            }
//        }
//    }
//    
//    // 2. action함수에 FirebaseAction 케이스에 대한 등록해주기
//    func action(
//        _ objectName: String,
//        _ eventName: String,
//        _ payload: [String : Any]? = nil
//    ) {
//        let event = FirebaseAction.create(eventName)
//        
//        switch event {
//        case .onPressed:
//            FirebaseAnalyticsManager.shared.sendGA(event.rawValue, payload)
//        case .onEditPressed:
//            FirebaseAnalyticsManager.shared.sendGA(event.rawValue)
//        case .onCancelPressed:
//            FirebaseAnalyticsManager.shared.sendGA(event.rawValue)
//        case .unRegistered:
//            print("Unregistered case detected. Check eventName and FirebaseStore's action.")
//        @unknown default:
//            print("This event is not registered as Firebase Analytics value.")
//        }
//        
//    }
//}


// 늘 사용하던 리듀서 형태 + 여기에 FirebaseAnalyzable을 붙임
//final class ExampleReducer: TKReducer, FirebaseAnalyzable {
//    var firebaseStore: any TKFirebaseStore = ExampleFirebaseStore()
//    
//    ////// 우리가 알던 TKReducer 부분
//    struct ViewState {
//        var status: String = "FirebaseTest변수"
//    }
//    
//    @Published var viewState: ViewState = ViewState()
//    
//    func callAsFunction<Value>(_ path: KeyPath<ViewState, Value>) -> Value where Value : Equatable {
//        self.viewState[keyPath: path]
//    }
//    
//    func reduce<Value>(_ path: WritableKeyPath<ViewState, Value>, into newValue: Value) where Value : Equatable {
//        self.viewState[keyPath: path] = newValue
//    }
//    
//    func onButtonPressed() {
//        self.reduce(\.status, into: "일반 버튼 눌림")
//        
//        let payload: [String: Any]? = [
//            "상태": self.viewState[keyPath: \.status]
//        ]
//        
//        firebaseAction(payload: payload)
//    }
//    
//    func onCancelButtonPressed() {
//        self.reduce(\.status, into: "취소 버튼 눌림")
//        
//        firebaseAction() // FireBase Analyzable
//    }
//    
//    func onEditPressed() {
//        self.reduce(\.status, into: "수정 버튼 눌림")
//        
//        firebaseAction() // FireBase Analyzable
//    }
//    //////
//}

// TestView
//struct FirebaseTestView: View {
//    var reducer: ExampleReducer = ExampleReducer()
//    
//    var body: some View {
//        VStack {
//            Button("일반") {
//                reducer.onButtonPressed()
//            }
//            
//            Button("취소") {
//                reducer.onCancelButtonPressed()
//            }
//            
//            Button("편집") {
//                reducer.onEditPressed()
//            }
//        }
//    }
//}









//     이 부분은 제안하고 싶은 부분. 현재 reducer에 FirebaseAnalytics를 달려고 하다보니 모든 메서드를 찾아가서
//    func onButtonPressed() {
//        로직 전개
//        ...
//        firebaseManager.sendGA()
//    }
//
//    func method2() {
//        로직 전개
//        ...
//        firebaseManager.sendGA()
//    }
//
//     리듀서 리팩터링 제안안
//
//     1. 리듀서 내부에 actions라는 enum을 내부적으로 하나 만들
//     2. 이 actions에는 사용자가 뷰에 하는 행동(action)들이 담김 -> 기존 리듀서 함수 이름 처럼 onButtonPressed 라던가...
//     3. 외부에서는 기존의 reducer.onButtonPressed(), reducer.onCancelPressed()처럼 각각의 메서드를 호출하는게 아니라
//      reducer.doAction(.buttonPressed), reducer.doAction(.cacelPressd)와 같이 doAction()이라는 하나의 메서드를 호출하고 대신 매개변수를 1에 있는 enum 값들 중 하나를 넣어줌
//     4. 그러면 doAction 함수 내부에서 switch case를 통해 각각의 행동에 대응하는 로직을 전개
//        switch action {
//        case .buttonPressed:
//            onButtonPressed()
//        case .cancelPressed:
//            onCancelPressed()
//        ...
//        }
//
//
//     단점:
//    1. 일단 할 일이 좀 더 늘어남(action에 case 추가, switch 문에 추가 etc),
//    2. 만들다 보니까 너무 TCA 패턴 같이 생김 ㅋ...
//
//     이러면 하나하나 일일이 리듀서 메서드 따로 파베 메서드 따로 만들 필요가 없이 하나의 doAction() 메서드(가제) 안에서 처리 할 수 있을것으로 보임
    
    
//    아마 이런식의 코드가 될 것으로 예상
    
//    part_1. 사용자 행동에 대한 enum들
//    enum SomeActionEnum {
//        case buttonPressed
//        case cancelPressed
//        case editPressed
//    }

//    part_2. 사용자 행동을 받아 switch문으로 분기 처리하는 함수
//    func doAction(_ action: SomeActionEnum) {
//        Task {
//            switch action {
//            case .buttonPressed:
//                onButtonPressed()
//            case .cancelPressed:
//                onCancelPressed()
//                ...
//            }
//
//            firebaseManager.shared.sendGA(action)
//        }
//    }
    
//    part_3. 각각의 행동들에 대한 메서드들
//    func onButtonPressed() { ... }
//    func onCancelPressed() { ... }
//    func onEditPressed() { ... }
    
    
//    part_4. 외부에서 사용하는 방법
//    reducer.doAction(.buttonPressed)
//    reducer.doAction(.cancelPressed)
//    reducer.doAction(.editPressed)
