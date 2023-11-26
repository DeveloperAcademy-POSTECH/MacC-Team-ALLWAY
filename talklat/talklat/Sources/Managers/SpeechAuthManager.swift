//
//  AppRootManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/07.
//

import Foundation
import Speech

// TODO: AppRootManager 에서 VoiceAuthManager로 수정
public class SpeechAuthManager {
    static let shared = SpeechAuthManager()
    
    static public var isSpeechRecognitionAuthorized: Bool = false
    static public var isMicrophoneAuthorized: Bool = false
    
    private init() { }
}

// MARK: - Switch Authorization Status
/// 시스템 마이크, 음성인식 권한 허용에 맞게 뷰를 반영합니다.
@MainActor
extension SpeechAuthManager {
    static func switchAuthStatus() async -> AuthStatus{
        await getAuthStatus()
        
        if isSpeechRecognitionAuthorized && isMicrophoneAuthorized == true {
            return .authCompleted
        } else if isSpeechRecognitionAuthorized == false && isMicrophoneAuthorized == true {
            return .speechRecognitionAuthIncompleted
        } else if isSpeechRecognitionAuthorized == true && isMicrophoneAuthorized == false {
            return .microphoneAuthIncompleted
        } else {
            return .authIncompleted
        }
    }
    
    static private func getAuthStatus() async {
        if await SFSpeechRecognizer.hasAuthorizationToRecognize() == true {
            isSpeechRecognitionAuthorized = true
        } else {
            isSpeechRecognitionAuthorized = false
        }
        
        if await AVAudioSession.sharedInstance().hasPermissionToRecord() == true {
            isMicrophoneAuthorized = true
        } else {
            isMicrophoneAuthorized = false
        }
    }
}
