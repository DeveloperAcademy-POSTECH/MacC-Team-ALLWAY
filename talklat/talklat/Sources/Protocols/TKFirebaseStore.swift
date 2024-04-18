//
//  TKFirebaseStore.swift
//  bisdam
//
//  Created by user on 4/6/24.
//

import Foundation
//import SwiftUI

protocol TKFirebaseStore {
    var viewId: String { get }
    
    associatedtype FirebaseAction: Equatable, FirebaseActionable where FirebaseAction.RawValue == String
    
    func userDidAction(
        _ actionType: UserActionType,
        _ additionalPayload: PayloadType?
    )
}

extension TKFirebaseStore {
    public func userDidAction(
        _ actionType: UserActionType,
        _ additionalPayload: PayloadType? = nil
    ) {
        
        var eventName: String
        switch actionType {
        case .tapped(.alertBack(_)):
            eventName = "\(actionType.gaValue())"
        case .tapped(.alertCancel(_)):
            eventName = "\(actionType.gaValue())"
        case .tapped(.alertDelete(_)):
            eventName = "\(actionType.gaValue())"
        default:
            eventName = "\(actionType.gaValue())_\(viewId)"
        }
        let payload: [String: Any] = assemblePayload(
            actionType,
            additionalPayload
        )
        
        //MARK: 테스트용 print, 배포때는 지울것
        print("""
              ======================
              이벤트 이름: \(eventName)
              데이터: \(payload)
              ======================
              """)
        
        
        FirebaseAnalyticsManager.shared.sendGA(
            eventName, 
            payload
        )
    }
    
    
    // 필요한 payload를 조립하는 함수
    private func assemblePayload(
        _ actionType: UserActionType ,
        _ additionalPayloadType: PayloadType? = nil
    ) -> [String: Any] {
        // 공통 payload 제작
        var payload: [String : Any] = [:]
        
        switch actionType {
        case .viewed:
            payload = createViewdPayload()
        case .tapped(let buttonId):
            payload = createButtonPayload(buttonId.rawValue())
        }
        
        // 추가 payload 제작
        if let additionalPayloadType = additionalPayloadType {
            var additionalPayload: [String : Any] = [:]
            
            switch additionalPayloadType {
            case .viewedType:
                additionalPayload = createViewdPayload()
            case .buttonType(let buttonId):
                additionalPayload = createButtonPayload(buttonId)
            case .allNearMeType(let conversations):
                additionalPayload = createAllNearMePayload(conversations)
            case .nearMeType(let conversation, let distance):
                additionalPayload = createNearMePayload(
                    conversation,
                    distance
                )
            case .historyType(let conversation, let location):
                additionalPayload = createHistoryPayload(conversation, location)
            case .textReplacementType(let shortText, let fullText):
                additionalPayload  = createTextReplacementPayload(
                    shortText,
                    fullText
                )
            case .guideMessageType(let guideMessage):
                additionalPayload = createGuideMessagePayload(guideMessage)
            }
            
            // 기존 payload에 추가 payload 병합하기
            payload.merge(additionalPayload) { (temporary, _) in
                temporary
            }
        }
        
        return payload
    }
    
    
    // 모든 진입시 공통 매개변수를 반환하는 함수
    private func createViewdPayload() -> [String : Any] {
        var payload: [String : Any] = [:]
        
        let viewId = viewId
        let viewEnterDate = Date.now.convertToDate(.korean)
        let viewEnterTime = Date.now.convertToTime(.korean)
        
        payload["viewId"] = viewId
        payload["viewEnterDate"] = viewEnterDate
        payload["viewEnterTime"] = viewEnterTime
        
        return payload
    }
    
    // 모든 버튼 공통 매개변수를 만드는 함수
    private func createButtonPayload(_ buttonID: String) -> [String : Any] {
        var payload: [String : Any] = [:]
        
        let buttonId: String = buttonID
        let buttonPressedDate: String = Date.now.convertToDate()
        let buttonPressedTime: String = Date.now.convertToTime()
        let buttonPressed: Bool = true
        
        payload["buttonId"] = buttonId
        payload["buttonPressedDate"] = buttonPressedDate
        payload["buttonPressedTime"] = buttonPressedTime
        payload["buttonPressed"] = buttonPressed
        
        return payload
    }
    
    // 근처 대화 항목 전체 매개변수를 만드는 함수
    private func createAllNearMePayload(_ conversations: [(Double, TKConversation)]) -> [String: Any] {
        var payload: [String: Any] = [:]
        
        var viewList = ""
        
        for (distance, conversation) in conversations {
            let currentConversationData = "\(conversation.title)_\(distance)_\(conversation.updatedAt?.convertToDate() ?? conversation.createdAt.convertToDate())|"
            
            viewList += currentConversationData
        }
        
        payload["viewList"] = viewList
        return payload
    }
    
    // 근처 대화 항목 매개변수를 만드는 함수
    private func createNearMePayload(
        _ item: TKConversation,
        _ itemDistance: Int
    ) -> [String : Any] {
        var payload: [String : Any] = [:]
        
        let itemId: String = item.title
        let itemDistance: Int = itemDistance
        let distanceUnit: String = "m"
        let itemSavedDate: String?
        let itemSavedTime: String?
        if let updatedAt = item.updatedAt {
            itemSavedDate = updatedAt.convertToDate()
            itemSavedTime = updatedAt.convertToTime()
        } else {
            itemSavedDate = item.createdAt.convertToDate()
            itemSavedTime = item.createdAt.convertToTime()
        }
        
        payload["itemId"] = itemId
        payload["itemDistance"] = itemDistance
        payload["distanceUnit"] = distanceUnit
        payload["itemSavedDate"] = itemSavedDate
        payload["itemSavedTime"] = itemSavedTime
        
        return payload
    }
    
    
    // 히스토리 항목 매개변수를 만드는 함수
    private func createHistoryPayload(
        _ conversation: TKConversation,
        _ locationName: String
    ) -> [String: Any] {
        var payload: [String: Any] = [:]
        
        let itemId = conversation.title
        var itemSavedDate: String
        var itemSavedTime: String
        if let updatedAt = conversation.updatedAt {
            itemSavedDate = updatedAt.convertToDate()
            itemSavedTime = updatedAt.convertToTime()
        } else {
            itemSavedDate = conversation.createdAt.convertToDate()
            itemSavedTime = conversation.createdAt.convertToTime()
        }
        let itemSavedAddress: String = locationName
        
        payload["itemId"] = itemId
        payload["itemSavedDate"] = itemSavedDate
        payload["itemSavedTime"] = itemSavedTime
        payload["itemSavedAddress"] = itemSavedAddress
        
        return payload
    }
    
    
    // 텍스트 대치 매개변수를 만드는 함수
    private func createTextReplacementPayload(
        _ itemShortText: String,
        _ itemFullText: String
    ) -> [String : Any] {
        var payload: [String : Any] = [:]
        
        payload["itemShortenText"] = itemShortText
        payload["itemFullText"] = itemFullText
        
        return payload
    }
    
    // 가이드 문구 매개변수를 만드는 함수
    private func createGuideMessagePayload(_ guideMessage: String) -> [String : Any] {
        return ["guideMessage" : guideMessage]
    }
    
}
