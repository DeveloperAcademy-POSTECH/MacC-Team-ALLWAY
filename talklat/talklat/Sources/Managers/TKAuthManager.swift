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
    case location = "위치"
    case authIncompleted
}

public class TKAuthManager: ObservableObject {
    @Published var authStatus: AuthStatus = .splash
    
    @Published public var isMicrophoneAuthorized: Bool = false
    @Published public var isSpeechRecognitionAuthorized: Bool = false
    @Published public var isLocationAuthorized: Bool = false
    
    private let isOnboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "ONBOARDING")
    
    init() {
        initAuthStatus()
    }
}

// MARK: - Switch Authorization Status
/// Microphone, SpeechRecognition, Location의 권한 요청을 보내고 / 권한 여부를 저장합니다.
extension TKAuthManager {
    private func initAuthStatus() {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            isMicrophoneAuthorized = true
        default:
            isMicrophoneAuthorized = false
        }
        
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            isSpeechRecognitionAuthorized = true
        default:
            isSpeechRecognitionAuthorized = false
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        default:
            isLocationAuthorized = false
        }
    }
    
    // 온보딩이 진행되었니?
    public func checkOnboardingCompletion() {
        if isOnboardingCompleted {
            checkAuthorizedCondition()
            authStatus = .requestAuthComplete
            
        } else {
            authStatus = .onboarding
        }
    }
    
    // 온보딩이 끝났다면 권한을 다 가져오고 complete한다.
    public func checkAuthorizedCondition() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await self.getMicrophoneAuthStatus()
                }
                
                group.addTask {
                    await self.getSpeechRecognitionAuthStatus()
                }
                
                group.addTask {
                    await self.getLocationAuthStatus()
                }
                
                await group.waitForAll()
            }
        }
        
        if isMicrophoneAuthorized,
           isSpeechRecognitionAuthorized,
           isLocationAuthorized {
            self.authStatus = .authCompleted
        } else {
            self.authStatus = .authIncompleted
        }
    }
    
    // Onboarding이 끝난 후
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
    
    @MainActor
    public func getSpeechRecognitionAuthStatus() async {
        if await SFSpeechRecognizer.hasAuthorizationToRecognize() == true {
            isSpeechRecognitionAuthorized = true
        } else {
            isSpeechRecognitionAuthorized = false
        }
    }
    
    @MainActor
    public func getLocationAuthStatus() async {
        let status = await CLLocationManager.requestAlwaysAuthorization()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        default:
            isLocationAuthorized = false
        }
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
