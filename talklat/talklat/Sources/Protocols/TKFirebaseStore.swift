//
//  TKFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/6/24.
//

import Foundation

protocol TKFirebaseStore {
    var viewID: String { get }
    
    associatedtype FirebaseAction: Equatable, FirebaseActionable where FirebaseAction.RawValue == String
    
    func userDidAction(
        _ actionType: UserActionType,
        _ eventName: String?,
        _ payload: [String: Any]?
    )
}

extension TKFirebaseStore {
    func userDidAction(
        _ actionType: UserActionType,
        _ eventName: String? = nil,
        _ payload: [String: Any]? = nil
    ) {
        //MARK: 테스트용 print, 배포때는 지울것
        print(
            "\(actionType.rawValue)_\(eventName)_\(viewID)",
            payload
        )
        
        switch actionType {
        case .viewed:
            FirebaseAnalyticsManager.shared.sendGA(
                "\(actionType.rawValue)_\(viewID)"
                , payload
            )
        case .tapped:
            sendTappedEvent(
                actionType,
                eventName,
                payload
            )
        }
    }
        
    
    private func sendTappedEvent(
        _ actionType: UserActionType,
        _ eventName: String? = nil,
        _ payload: [String: Any]? = nil
    ) {
        if let eventName = eventName {
            let event = FirebaseAction.create(eventName)
            
            switch event {
            case .unRegistered:
                print("EventName \(eventName) is not registered in \(String(describing: type(of: self))). Please Check again :(")
            default:
                FirebaseAnalyticsManager.shared.sendGA(
                    "\(actionType.rawValue)_\(event.rawValue.capitalized)_\(viewID)",
                    payload
                )
            }
        } else {
            print("No Event Name passed to tapped Event procedure. Please check again :(")
        }
    }
}
