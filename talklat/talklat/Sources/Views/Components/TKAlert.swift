//
//  TKFloatingView.swift
//  talklat
//
//  Created by Celan on 11/14/23.
//

import SwiftUI
import UIKit

struct TKAlert<ConfirmButtonLabel: View>: View {
    @EnvironmentObject var authManager: TKAuthManager
    @Binding var bindingPresentedFlag: Bool
    
    let alertStyle: AlertStyle
    let confirmButtonAction: () -> Void
    let confirmButtonLabel: () -> ConfirmButtonLabel
    let dismissAction: (() -> Void)?
    
    // MARK: init
    init(
        style alertStyle: AlertStyle,
        isPresented: Binding<Bool>,
        confirmButtonAction: @escaping () -> Void,
        @ViewBuilder confirmButtonLabel: @escaping () -> ConfirmButtonLabel
    ) {
        self.alertStyle = alertStyle
        self._bindingPresentedFlag = isPresented
        self.confirmButtonAction = confirmButtonAction
        self.confirmButtonLabel = confirmButtonLabel
        self.dismissAction = nil
    }
    
    init(
        style alertStyle: AlertStyle,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)?,
        confirmButtonAction: @escaping () -> Void,
        @ViewBuilder confirmButtonLabel: @escaping () -> ConfirmButtonLabel
    ) {
        self.alertStyle = alertStyle
        self._bindingPresentedFlag = isPresented
        self.dismissAction = onDismiss
        self.confirmButtonAction = confirmButtonAction
        self.confirmButtonLabel = confirmButtonLabel
    }
    
    // MARK: BODY
    var body: some View {
        switch alertStyle {
        case .conversation:
            ZStack {
                VStack(
                    alignment: .leading,
                    spacing: 32
                ) {
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        image
                            .scaleEffect(1.3)
                            .foregroundStyle(tintColor)
                            .padding(.top, 32)
                        
                        eachAuthStatusView()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                    
                    alertBottomButtonBuilder()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
                .background { Color.AlertBGWhite }
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(.horizontal, 32)
            }
            
        case
                .editCancellation(_),
                .conversationCancellation,
                .removeConversation(_),
                .removeTextReplacement(_):
            ZStack {
                VStack(
                    alignment: .center,
                    spacing: 16
                ) {
                    image
                        .scaleEffect(1.3)
                        .foregroundStyle(tintColor)
                    
                    BDText(text: headerTitle, style: .H1_B_130)
                        .foregroundStyle(Color.GR9)
                        .multilineTextAlignment(.center)
                        .lineSpacing(0)
                    
                    BDText(text: description, style: .H2_SB_135)
                        .foregroundStyle(Color.GR6)
                        .multilineTextAlignment(.center)
                        .lineLimit(3, reservesSpace: true)
                        .padding(.bottom, 16)
                    
                    alertBottomButtonBuilder()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                }
                .padding(.top, 32)
                .background { Color.AlertBGWhite }
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(.horizontal, 32)
            }
        }
    }
    
    @ViewBuilder
    private func eachAuthStatusView() -> some View {
        if let isMicrophoneAuthorized = authManager.isMicrophoneAuthorized,
           let isSpeechRecognitionAuthorized = authManager.isSpeechRecognitionAuthorized {
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                BDText(text: getConversationAuthTitle(), style: .H1_B_130)
                    .foregroundStyle(Color.GR9)
                
                BDText(text: getConversationAuthDescription(), style: .H2_SB_135)
                    .foregroundStyle(Color.GR6)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4, reservesSpace: true)
                    .padding(.bottom, 16)
                
                HStack {
                    Image(
                        systemName: isMicrophoneAuthorized
                        ? "checkmark.circle.fill"
                        : "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        isMicrophoneAuthorized
                        ? Color.green
                        : Color.RED
                    )
                    
                    BDText(text: NSLocalizedString("microphoneAccessPermission", comment: "Microphone access permission"), style: .H2_SB_135)
                }
                
                HStack {
                    Image(
                        systemName: isSpeechRecognitionAuthorized
                        ? "checkmark.circle.fill"
                        : "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        isSpeechRecognitionAuthorized
                        ? Color.green
                        : Color.RED
                    )
                    
                    BDText(text: NSLocalizedString("speechRecognitionPermission", comment: "Speech recognition permission"), style: .H2_SB_135)
                }
            }
            .font(.subheadline.weight(.semibold))
        }
    }
    
    private func alertBottomButtonBuilder() -> some View {
        HStack(spacing: 9) {
            Button {
                if let dismissAction = dismissAction {
                    dismissAction()
                }
                withAnimation {
                    bindingPresentedFlag = false
                }
            } label: {
                BDText(text: dismissText, style: .H2_SB_135)
                    .foregroundStyle(Color.GR6)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.GR2)
                    }
            }
            
            Button {
                confirmButtonAction()
            } label: {
                confirmButtonLabel()
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(tintColor)
                    }
            }
        }
    }
}

extension TKAlert {
    private func getConversationAuthTitle() -> String {
        if let isMicrophoneAuthorized = authManager.isMicrophoneAuthorized,
           let isSpeechAuthorized = authManager.isSpeechRecognitionAuthorized {
            if isMicrophoneAuthorized, !isSpeechAuthorized {
                return NSLocalizedString("speech.permission.denied", comment: "")
            }
            else if !isMicrophoneAuthorized, isSpeechAuthorized {
                return NSLocalizedString("mic.permission.denied", comment: "")
            }
            else if !isMicrophoneAuthorized, !isSpeechAuthorized {
                return NSLocalizedString("mic.speech.permission.denied", comment: "")
            }
        }
        
        return ""
    }
    
    private func getConversationAuthDescription() -> String {
        if let isMicrophoneAuthorized = authManager.isMicrophoneAuthorized,
           let isSpeechAuthorized = authManager.isSpeechRecognitionAuthorized {
            if isMicrophoneAuthorized, !isSpeechAuthorized {
                return NSLocalizedString("alert.speech.permission", comment: "")
            }
            else if !isMicrophoneAuthorized, isSpeechAuthorized {
                return NSLocalizedString("alert.microphone.permission", comment: "")
            }
            else if !isMicrophoneAuthorized, !isSpeechAuthorized {
                return NSLocalizedString("alert.conversation.permission", comment: "")
            }
        }
        
        return ""
    }
    
    enum AlertStyle {
        case conversation
        case editCancellation(title: String)
        case conversationCancellation
        case removeTextReplacement(title: String)
        case removeConversation(title: String)
    }
    
    var tintColor: Color {
        switch alertStyle {
        case .conversation, .editCancellation, .conversationCancellation: Color.OR5
        case .removeTextReplacement, .removeConversation(_): Color.RED
        }
    }
    
    var image: Image {
        switch alertStyle {
        case .conversation, .editCancellation, .conversationCancellation: Image(systemName: "exclamationmark.triangle.fill")
        case .removeTextReplacement, .removeConversation(_): Image(systemName: "trash.fill")
        }
    }
    
    private var headerTitle: String {
        switch alertStyle {
        case .editCancellation: return NSLocalizedString("alert.editCancellation.title", comment: "변경 사항 취소")
        case .conversationCancellation: return NSLocalizedString("alert.conversationCancellation.title", comment: "대화를 그만하시겠어요?")
        case .removeTextReplacement: return NSLocalizedString("alert.removeTextReplacement.title", comment: "텍스트 대치 삭제")
        case .removeConversation: return NSLocalizedString("alert.removeConversation.title", comment: "대화 삭제")
        default: return ""
        }
    }
    
    var description: String {
        switch alertStyle {
        case .conversation:
            return NSLocalizedString("alert.conversation.permission", comment: "마이크와 음성 인식 접근 권한 요청")
        case .editCancellation:
            return NSLocalizedString("alert.editCancellation.description", comment: "변경 사항 취소 설명")
        case .conversationCancellation:
            return NSLocalizedString("alert.conversationCancellation.description", comment: "대화 취소 설명")
        case .removeTextReplacement:
            return NSLocalizedString("alert.removeTextReplacement.description", comment: "텍스트 대치 삭제 설명")
        case let .removeConversation(conversationTitle):
            let formatString = NSLocalizedString("alert.removeConversation.description", comment: "대화 삭제 설명")
            return String(format: formatString, conversationTitle)
        }
    }
    
    private var dismissText: String {
        switch alertStyle {
        case .conversation: return NSLocalizedString("alert.conversation.dismiss", comment: "돌아가기")
        case .editCancellation, .removeTextReplacement, .removeConversation(_): return NSLocalizedString("alert.dismiss.noThanks", comment: "아니요, 취소할래요")
        case .conversationCancellation: return NSLocalizedString("alert.conversationCancellation.dismiss", comment: "아니요")
        }
    }
}


struct PreviewPro: PreviewProvider {
    @State static var flag = true
    
    static var previews: some View {
        NavigationStack {
            Button {
                flag.toggle()
                print(flag)
            } label: {
                Text("???")
            }
        }
        .showTKAlert(
            isPresented: $flag,
            style: .conversation,
            confirmButtonAction: {
                print("conf")
            },
            confirmButtonLabel: {
                HStack {
                    Text("허용하러 가기")
                }
            }
        )
        .environmentObject(TKAuthManager())
    }
}
