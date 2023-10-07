//
//  AppRootManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/07.
//

import Foundation
import Speech

public class AppRootManager: ObservableObject {
    public enum AuthStatus: String {
        case authCompleted
        case speechRecognitionAuthIncompleted = "음성 인식"
        case microphoneAuthIncompleted = "마이크"
        case authIncompleted = "마이크, 음성"
    }
    
    @Published var currentRoot: AuthStatus = .authCompleted
    
    var isSpeechRecognitionAuthorized: Bool = true
    var isMicrophoneAuthorized: Bool = true
}

// MARK: - Switch Authorization Status
/// 시스템 마이크, 음성인식 권한 허용에 맞게 뷰를 반영합니다.
@MainActor
extension AppRootManager {
    public func switchAuthStatus() async {
        await getAuthStatus()
        
        if isSpeechRecognitionAuthorized && isMicrophoneAuthorized == true {
            currentRoot = .authCompleted
        } else if isSpeechRecognitionAuthorized == false && isMicrophoneAuthorized == true {
            currentRoot = .speechRecognitionAuthIncompleted
        } else if isSpeechRecognitionAuthorized == true && isMicrophoneAuthorized == false {
            currentRoot = .microphoneAuthIncompleted
        } else {
            currentRoot = .authIncompleted
        }
    }
    
    private func getAuthStatus() async {
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
