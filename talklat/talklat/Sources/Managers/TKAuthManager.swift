//
//  TKAuthManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/16/23.
//

import CoreLocation
import Foundation
import MapKit
import Speech
import SwiftUI

public enum AuthStatus: String {
    case splash
    case authCompleted
    case microphoneAuthIncompleted = "마이크"
    case speechRecognitionAuthIncompleted = "음성 인식"
    case locationAuthIncompleted = "위치"
    case authIncompleted
}

public class TKAuthManager: ObservableObject {
    @Published var authStatus: AuthStatus = .splash
    
    @Published public var isMicrophoneAuthorized: Bool = false
    @Published public var isSpeechRecognitionAuthorized: Bool = false
    @Published public var isLocationAuthorized: Bool = false
    
    init() { }
}

// MARK: - Get / Switch Authorization Status
/// Microphone, SpeechRecognition, Location의 권한 요청을 보내고 / 권한 여부를 저장합니다.
@MainActor
extension TKAuthManager {
    public func getMicrophoneAuthStatus() async {
        if await AVAudioSession.sharedInstance().hasPermissionToRecord() == true {
            isMicrophoneAuthorized = true
        } else {
            isMicrophoneAuthorized = false
        }
    }
    
    public func getSpeechRecognitionAuthStatus() async {
        if await SFSpeechRecognizer.hasAuthorizationToRecognize() == true {
            isSpeechRecognitionAuthorized = true
        } else {
            isSpeechRecognitionAuthorized = false
        }
    }
    
    public func getLocationAuthStatus() async {
        let status = await CLLocationManager.requestAlwaysAuthorization()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        default:
            isLocationAuthorized = false
        }
    }
    
    public func switchAuthStatus() {
        authStatus = .authIncompleted
//        if isMicrophoneAuthorized == true && isSpeechRecognitionAuthorized == true && isLocationAuthorized == true {
//            authStatus = .authCompleted
//        } else if isMicrophoneAuthorized == false && isSpeechRecognitionAuthorized == true && isLocationAuthorized == true {
//            authStatus = .microphoneAuthIncompleted
//        } else if isSpeechRecognitionAuthorized == false && isMicrophoneAuthorized == true && isLocationAuthorized == true {
//            authStatus = .speechRecognitionAuthIncompleted
//        } else if isLocationAuthorized == false && isMicrophoneAuthorized == true && isSpeechRecognitionAuthorized == true {
//            authStatus = .locationAuthIncompleted
//        } else if isMicrophoneAuthorized, isSpeechRecognitionAuthorized, isLocationAuthorized == false {
//            authStatus = .authIncompleted
//        }
    }
}

// MARK: - Location Manger Request Extension
extension CLLocationManager {
    static func requestAlwaysAuthorization() async -> CLAuthorizationStatus {
        let instance = CLLocationManager()
        instance.requestAlwaysAuthorization()
        
        return instance.authorizationStatus
    }
}
