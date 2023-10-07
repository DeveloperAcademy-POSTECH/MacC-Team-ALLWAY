//
//  AppRootManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/07.
//

import Foundation
import Speech

public class AppRootManager: ObservableObject {
    @Published var currentRoot: StartMode = .authCompleted

    public enum StartMode: String {
        case authCompleted
        case speechRecognitionAuthIncompleted = "음성 인식"
        case microphoneAuthIncompleted = "마이크"
        case authIncompleted = "마이크, 음성"
    }
}

// MARK: - Switch Authorization Status
/// 시스템 마이크, 음성인식 권한 허용에 맞게 뷰를 반영합니다.
@MainActor
extension AppRootManager {
    public func switchAuthorizationStatus() async {
        var isSpeechRecognitionAuthorized: Bool = true
        var isMicrophoneAuthorized: Bool = true
        
        if await SFSpeechRecognizer.hasAuthorizationToRecognize() == true {
            isSpeechRecognitionAuthorized = true
            print("음성 인식 허용 됨!")
            
        } else {
            isSpeechRecognitionAuthorized = false
            print("음성 인식 허용 안됨ㅠ")
        }
        
        if await AVAudioSession.sharedInstance().hasPermissionToRecord() == true {
            isMicrophoneAuthorized = true
            print("마이크 허용 됨!")
        } else {
            isMicrophoneAuthorized = false
            print("마이크 허용 안됨ㅠ")
        }
        
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
}
