//
//  FirebaseAnalyticsManager.swift
//  bisdam
//
//  Created by user on 3/5/24.
//

import FirebaseAnalytics
import Foundation


struct FirebaseAnalyticsManager {
    static var shared: FirebaseAnalyticsManager = FirebaseAnalyticsManager()
    
    // 실제 GA를 보내는 메서드 -> 비동기로 작업 (이건 좀 찾아봐야함, 서버에 즉시즉시 올리는지 or 아니면 모아뒀다가 한꺼번에 올리는지 잘 모르겠음)
    public func sendGA(
        _ eventName: String,
        _ payload: [String: Any]? = nil
    ) {
        //MARK: 추후에 Async Await 를 이용한 비동기 처리로 바꾸기
        DispatchQueue.global().async {
            Analytics.logEvent(eventName, parameters: payload)
        }
    }
}
