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
    상대방에게 보여주고 싶은 내용을 작성해 주세요.
    """
    
    static let GUIDE_MESSAGE: String =
    """
    저는 청각장애가 있어요.
    음성 인식을 위해 천천히 크게 말해주세요.
    """
}

public enum AuthStatus: String {
    case authCompleted
    case speechRecognitionAuthIncompleted = "음성 인식"
    case microphoneAuthIncompleted = "마이크"
    case authIncompleted = "마이크, 음성"
}

public enum FlippedStatus: String {
    case opponent
    case myself
}
