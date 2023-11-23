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
    case onboarding
    case requestAuthComplete
    case microphoneAuthIncompleted = "마이크"
    case speechRecognitionAuthIncompleted = "음성 인식"
    case locationAuthIncompleted = "위치"
    case authIncompleted
}

public class TKAuthManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authStatus: AuthStatus = .splash
    
    @Published public var isMicrophoneAuthorized: Bool?
    @Published public var isSpeechRecognitionAuthorized: Bool?
    @Published public var isLocationAuthorized: Bool?
    
    private let isOnboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "ONBOARDING")
    private let locationManager: CLLocationManager = CLLocationManager()
    
    private var hasAuthBeenRequested: Bool {
        self.isMicrophoneAuthorized != nil &&
        self.isLocationAuthorized != nil &&
        self.isSpeechRecognitionAuthorized != nil
    }
    
    public var hasAllAuthBeenObtained: Bool {
        if let isMicrophoneAuthorized, isMicrophoneAuthorized,
           let isSpeechRecognitionAuthorized, isSpeechRecognitionAuthorized,
           let isLocationAuthorized, isLocationAuthorized {
            return true
        } else {
            return false
        }
    }
    
    override init() {
        super.init()
        checkCurrentAuthorizedCondition()
    }
}

// MARK: - Get / Switch Authorization Status
/// Microphone, SpeechRecognition, Location의 권한 요청을 보내고 / 권한 여부를 저장합니다.
@MainActor
extension TKAuthManager {
    public func checkCurrentAuthorizedCondition() {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            isMicrophoneAuthorized = true
            
        case .denied:
            isMicrophoneAuthorized = false
            
        default:
            break
        }
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            isSpeechRecognitionAuthorized = true
            
        case .denied, .restricted:
            isSpeechRecognitionAuthorized = false
            
        default:
            break
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
            
        case .denied, .restricted:
            isLocationAuthorized = false
            
        default:
            break
        }
    }
    
    // 온보딩이 진행되었니?
    public func checkOnboardingCompletion() {
        if isOnboardingCompleted {
            // 온보딩이 되었다면, 권한 상태를 가져온다.
            print("온보딩이 되었다면, 권한 상태를 가져온다.")
            checkCurrentAuthorizedCondition()
            authStatus = .requestAuthComplete
            
        } else if hasAuthBeenRequested {
            // 기기에 각 권한이 모두 한 번 이상 요청된 흔적이 남아있다면 onboarding이 끝난 것으로 분기 처리 한다.
            print("기기에 권한이 요청된 흔적이 남아있다면 onboarding이 끝난 것으로 분기 처리 한다.")
            onOnboardingCompleted()
        } else {
            // 온보딩 한 적도, 권한 요청 흔적도 없다면 온보딩을 시작한다.
            print("온보딩 한 적도, 권한 요청 흔적도 없다면 온보딩을 시작한다.")
            withAnimation {
                authStatus = .onboarding
            }
        }
    }
    
    public func onOnboardingCompleted() {
        UserDefaults.standard.setValue(true, forKey: "ONBOARDING")
        authStatus = .requestAuthComplete
    }
    
    @MainActor
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        case .denied, .restricted:
            isLocationAuthorized = false
        case .notDetermined:
            break
        default:
            break
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
