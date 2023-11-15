//
//  Constants.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import Foundation
import SwiftUI

public enum Constants {
    static let TEXTFIELD_PLACEHOLDER: String =
    """
    내용을 작성해 주세요.
    """
    
    static let GUIDE_MESSAGE: String =
    """
    저는 청각장애가 있어요.
    말씀하신 내용은 음성인식되어서
    텍스트로 변환됩니다.
    """
    
    static let SECOND_GUIDE_MESSAGE: String =
    """
    저는 청각장애가 있어요.
    말씀하신 내용은 음성인식되어서
    텍스트로 변환됩니다.
    """
    
    static let SectionIndexTitles = ["#", "ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    static let TEXTFIELD_MESSAGE: String =
    """
    한 글자 이상 입력해주세요
    """
    
    static let START_CONVERSATION_MESSAGE: String =
    """
    새 대화
    시작하기
    """
    
}

public enum AuthStatus: String {
    case splash
    case authCompleted
    case speechRecognitionAuthIncompleted = "음성 인식"
    case microphoneAuthIncompleted = "마이크"
    case authIncompleted = "마이크, 음성"
}

public enum FlippedStatus: String {
    case opponent
    case myself
}

public enum EachCommunicationArea {
    case writingArea
    case neutralArea
    case recordingArea
}

public enum TKTransitionObjects {
    case QUESTION
    case ANSWER
    case INTERLUDE
}

public enum conversationPatterns {
    static let questionPatterns: [String] = ["나요", "가요", "까요", "입니까"]
    static let explanationPatterns: [String] = ["입니다", "합니다"]
}

// HistoryItem이 없어지고 enum이 public이 될 것
public enum MessageType: String {
    case question = "question"
    case answer = "answer"
}

public enum LocationCallType {
    case update
    case get
}

public enum LocationAuthorizationStatus {
    case notAuthorized
    case noCoordinate
    case authorized
}

public enum BlockNameType {
    case fullName
    case shortName
}

enum MapAnnotationType {
    case fixed
    case movable
}

public let initialLatitude: Double = 37.554577
public let initialLongitude: Double = 126.970828


public enum HistoryViewType {
    case preview
    case item
}
