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

public enum VisibleStatus {
    case visible
    case hidden
}

public enum TextType {
    case inComming
    case outGoing
}


// Dummy ChatMessages: To be deleted
// short
public var shortMessages: [[ChatMessage]] = [
    [
        ChatMessage(text: "Here is my first message", textType: .inComming, date: "23/05/25"),
        ChatMessage(text: "I'm going to message another long message that will word wrap", textType: .inComming, date: "23/05/25")
    ]
]

// middle
public let middleMessages: [[ChatMessage]] = [
    [
        ChatMessage(text: "Here is my first message", textType: .inComming, date: "23/05/25"),
        ChatMessage(text: "I'm going to message another long message that will word wrap", textType: .inComming, date: "23/05/25")
    ],
    [
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .outGoing, date: "23/05/26"),
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .inComming, date: "23/05/26"),
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .outGoing, date: "23/05/26")
    ],
    [
        ChatMessage(text: "I'm going to message another long message that will word wrap ", textType: .inComming, date: "23/05/27"),
        ChatMessage(text: "whaddup dawg", textType: .outGoing, date: "23/05/27"),
        ChatMessage(text: "I'm going to message another long message that will word wrap ", textType: .inComming, date: "23/05/27"),
        ChatMessage(text: "whaddup dawg", textType: .outGoing, date: "23/05/27")
    ],
    [
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .inComming, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
    ],
]

// long
public let longMessages: [[ChatMessage]] = [
    [
        ChatMessage(text: "Here is my first message", textType: .inComming, date: "23/05/25"),
        ChatMessage(text: "I'm going to message another long message that will word wrap", textType: .inComming, date: "23/05/25")
    ],
    [
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .outGoing, date: "23/05/26"),
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .outGoing, date: "23/05/26"),
        ChatMessage(text: "I'm going to message another long message that will word wrap I'm going to message another long message that will word wrap", textType: .outGoing, date: "23/05/26")
    ],
    [
        ChatMessage(text: "I'm going to message another long message that will word wrap ", textType: .inComming, date: "23/05/27"),
        ChatMessage(text: "whaddup dawg", textType: .outGoing, date: "23/05/27"),
        ChatMessage(text: "I'm going to message another long message that will word wrap ", textType: .inComming, date: "23/05/27"),
        ChatMessage(text: "whaddup dawg", textType: .outGoing, date: "23/05/27")
    ],
    [
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .inComming, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/28"),
    ],
    [
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/29"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .inComming, date: "23/05/29"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/29"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/29"),
    ],
    [
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/30"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .inComming, date: "23/05/30"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/30"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/30"),
    ],
    [
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/31"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .inComming, date: "23/05/31"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/31"),
        ChatMessage(text: ".", textType: .inComming, date: ""),
        ChatMessage(text: ".", textType: .outGoing, date: ""),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/31"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/31"),
        ChatMessage(text: "Fourth ChatMessage on the way", textType: .outGoing, date: "23/05/31")
    ]
]

