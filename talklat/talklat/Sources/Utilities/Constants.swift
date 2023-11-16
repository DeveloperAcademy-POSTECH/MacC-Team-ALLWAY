//
//  Constants.swift
//  talklat
//
//  Created by Celan on 2023/10/09.
//

import Foundation
import MapKit
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
    
    enum Onboarding {
        static let GUIDE_MESSAGE: String =
    """
    토크랫을 이용하기 전,
    원활한 사용을 위해
    몇가지 설정을 해야 해요.
    """
        static let MIC: String =
        """
        토크랫은 사용자가 대화하고자 하는
        상대방의 음성을 인식하기 위해
        마이크 권한을 필요로 합니다.
        """
        
        static let SPEECH: String =
        """
        토크랫은 인식한 상대방의 음성을
        텍스트로 변환하기 위해 마이크와 함께
        음성 인식 권한을 필요로 합니다.
        """
        
        static let LOCATION: String =
        """
        토크랫은 사용자가 이전에 대화한
        장소를 방문할 경우 이어 대화하기를
        제안하기 위해 정확한 위치 켬과
        위치 정보 권한을 필요로 합니다.
        """
        
        static let ALL_AUTH: String =
        """
        좋아요!
        이제 토크랫을
        이용해 볼까요?
        """
        
        static let NOT_ALL_AUTH: String =
        """
        저런:(
        모든 권한을
        허용하지 않았네요.
        """
    }
    
    
    static let SectionIndexTitles = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    
    static let START_CONVERSATION_MESSAGE: String =
    """
    새 대화
    시작하기
    """
    
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

public var initialCoordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
        latitude: initialLatitude,
        longitude: initialLongitude
    ),
    latitudinalMeters: 500,
    longitudinalMeters: 500
)
