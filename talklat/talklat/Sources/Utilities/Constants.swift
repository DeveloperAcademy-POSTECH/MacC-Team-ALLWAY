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
    static let TEXTFIELD_PLACEHOLDER: String = NSLocalizedString("CtextfieldPlaceholder", comment: "ConversationView 텍스트 필드의 플레이스홀더")
    
    //    static let TEXTFIELD_PLACEHOLDER: String =
    //    """
    //    내용을 작성해 주세요.
    //    """
    //
    
    static let GUIDE_MESSAGE: String = NSLocalizedString("CguideMessage", comment: "청각장애 안내 메시지")
    
    //    static let GUIDE_MESSAGE: String =
    //    """
    //    저는 청각장애가 있어요.
    //    말씀하신 내용은 음성인식되어서
    //    텍스트로 변환됩니다.
    //    """
    //
    
    static let SECOND_GUIDE_MESSAGE: String = NSLocalizedString("CsecondguideMessage", comment: "청각장애 안내 메시지")
    
    //    static let SECOND_GUIDE_MESSAGE: String =
    //    """
    //    저는 청각장애가 있어요.
    //    말씀하신 내용은 음성인식되어서
    //    텍스트로 변환됩니다.
    //    """
    
    static let SectionIndexTitles = ["#", "ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    static let TEXTFIELD_MESSAGE: String = NSLocalizedString("constants.textfield.message", comment: "")
    
    //    static let TEXTFIELD_MESSAGE: String =
    //    """
    //    한 글자 이상 입력해주세요
    //    """
    
    enum Onboarding {
        static let GUIDE_MESSAGE: String = NSLocalizedString("onboardingGuideMessage", comment: "")
        //        static let GUIDE_MESSAGE: String =
        //        """
        //        비스담을 이용하기 전,
        //        원활한 사용을 위해
        //        몇가지 설정을 해야 해요.
        //        """
        static let CONVERSATION: String = NSLocalizedString("onboardingConversation", comment: "")
        
        //        static let CONVERSATION: String =
        //        """
        //        비스담은 당신이 대화하고자 하는 상대방의 음성을 인식하기 위해 마이크 권한을 필요로 하며, 인식한 상대방의 음성을 텍스트로 변환하기 위해 음성 인식 권한을 필요로 해요.
        //        """
        
        
        static let SPEECH: String = NSLocalizedString("onboarding.sppech", comment: "")
        
        //        static let SPEECH: String =
        //        """
        //        비스담은 인식한 상대방의 음성을
        //        텍스트로 변환하기 위해 마이크와 함께
        //        음성 인식 권한을 필요로 합니다.
        //        """
        
        static let LOCATION: String = NSLocalizedString("onboardingLocation", comment: "")
        //
        //        static let LOCATION: String =
        //        """
        //        비스담은 사용자가 이전에 대화한
        //        장소를 방문할 경우 이어 대화하기를
        //        제안하기 위해 정확한 위치 켬과
        //        위치 정보 권한을 필요로 합니다.
        //        """
        
        static let ALL_AUTH: String = NSLocalizedString("onboardingAllAuth", comment: "")
        //        static let ALL_AUTH: String =
        //        """
        //        좋아요!
        //        이제 비스담을
        //        이용해 볼까요?
        //        """
        
        static let NOT_ALL_AUTH: String = NSLocalizedString("onboardingNotAllAuth", comment: "")
        //        static let NOT_ALL_AUTH: String =
        //        """
        //        저런:(
        //        허용하지 않은
        //        권한이 있군요.
        //        """
        
        
        static let CHANGE_AUTH_GUIDE: String = NSLocalizedString("onboarding.change.auth.guide", comment: "")
        
        //        static let CHANGE_AUTH_GUIDE: String = "나중에 설정에서 권한을 다시 변경할 수 있어요."
        
        
        static let ASK_FOR_AUTH_ALL_GUIDE: String = NSLocalizedString("onaboarding.ask.for.auth.all.guide", comment: "")
        
        //        static let ASK_FOR_AUTH_ALL_GUIDE: String =
        //        """
        //        원활한 앱 사용을 위해
        //        앱 설정에서 모든 권한을 허용해 주세요.
        //        """
    }
  
    enum Conversation {
      static let NO_RESPONSE: String =
      """
      (기록된 답변이 없어요.)
      """
    }
    
    static let START_CONVERSATION_MESSAGE: String = NSLocalizedString("startConversationMessage", comment: "")
   
//    static let START_CONVERSATION_MESSAGE: String =
//    """
//    새 대화
//    시작하기
//    """
    static let SHOWINGVIEW_GUIDINGMESSAGE: String = NSLocalizedString("showingViewGuidingMessage", comment: "")
//    """
//    음성인식이 되고 있어요.
//    또박또박 말씀해 주세요.
//    """
    
    static let CONVERSATION_GUIDINGMESSAGE: String = NSLocalizedString("settings.guiding.edit.fixedMessage", comment: "")
//    """
//    잠시 후에 음성인식이 시작됩니다.
//    제 글을 읽고 또박또박 말씀해 주세요.
//    """
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

public enum ConversationPatterns {
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

public enum HistoryInfoLocationStatus {
    case locationNotChanged
    case locationChanged
}

public enum HistoryInfoTextStatus {
    case textEmpty
    case textNotChanged
    case textChanged
}

internal enum UserActionType {
    case viewed
    case tapped(TappedType)
    
    func gaValue() -> String {
        switch self {
        case .viewed:
            return "viewed"
        case .tapped(let tappedType):
            return "tapped_\(tappedType.rawValue().capitalizeOnlyFirstLetter())"
        }
    }
}

internal enum PayloadType {
    case viewedType
    case buttonType(String)
    case nearMeType(TKConversation, Int)
    case historyType(TKConversation, String)
    case textReplacementType(String, String)
    case guideMessageType(String)
    case allNearMeType([(Double,TKConversation)])
}

enum TappedType {
    // view이름들
    case history
    case setting
    case newConversation
    case permit
    case back
    case nearMeItem
    
    // user행동들
    case cancel
    case save
    case field
    case eraseAll
    case next
    case textReplace
    case goToTypingView
    case edit
    case discloseSection
    case item
    case add
    case complete
    case select
    case delete
    case alertBack(String)
    case alertCancel(String)
    case alertDelete(String)
    case adjustLocation
    case close
    case map
    case myLocation
    case pointPin
    
    case guideMessage
    case displayMode
    case personalInfo
    case makers
    case help
    
    case speechPermit
    case locationPermit
    case indexBar
    case shortenTextField
    case fullTextField
    
    case toggle
    case editGuideMessage
    case preview
    case guideMesageField
    case sameMode
    case lightMode
    case darkMode
    case mail
    case send
    
    func rawValue() -> String {
        switch self {
        case .alertBack(let viewId):
            return "alertBack_\(viewId)"
        case .alertCancel(let viewId):
            return "alertCancel_\(viewId)"
        case .alertDelete(let viewId):
            return "alertDelete_\(viewId)"
        default:
            return String(describing: self)
        }
    }
}


public enum LocaleType: String {
    case korean = "ko_KR"
    case english = "en_EN" // 이거 맞나?
}
