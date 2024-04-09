//
//  TKOnboardingView.swift
//  talklat
//
//  Created by Celan on 11/16/23.
//

import SwiftUI

struct TKOnboardingView: View {
    #warning("추후 app 에서 호출하고 status를 관리하게 될 예정")
    #warning("View 에서 로직 분리 필요")
    @ObservedObject var authManager: TKAuthManager
    
    struct OnboardingInfo: Equatable {
        var title: String
        var description: String
        var highlightTarget: [String]
    }
    
    enum OnboardingStep: Equatable {
        case start
        case conversation(OnboardingInfo)
        case location(OnboardingInfo)
        case complete
    }
    
    @State private var onboardingStep: OnboardingStep = .start
    @State private var onboardInfo: OnboardingInfo = OnboardingInfo(
        title: "",
        description: "",
        highlightTarget: []
    )
        
    var body: some View {
        VStack {
            if case .start = onboardingStep {
                onboardingStartGuideView()
            }
            
            if case let .conversation(info) = onboardingStep {
                TKOnboardingAuthReqeustView(
                    parentInfo: $onboardInfo,
                    info: info
                )
            }
            
            if case let .location(info) = onboardingStep {
                TKOnboardingAuthReqeustView(
                    parentInfo: $onboardInfo,
                    info: info
                )
            }
            
            if case .complete = onboardingStep {
                VStack(
                    alignment: .leading,
                    spacing: 32
                ) {
                    // MARK: CONDITION
                    if authManager.hasAllAuthBeenObtained {
                        BDText(text: Constants.Onboarding.ALL_AUTH, style: .LT_B_160)
                            .fixedSize()
                            .foregroundStyle(Color.OR6)
                        
                    } else {
                        BDText(text: Constants.Onboarding.NOT_ALL_AUTH, style: .LT_B_160)
                            .fixedSize()
                            .foregroundStyle(Color.OR6)
                    }
                    
                    eachAuthStatusView()
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .frame(
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .safeAreaInset(edge: .bottom) {
            onboardingBottomFooter(info: onboardInfo)
        }
        .onChange(of: authManager.isMicrophoneAuthorized) { _, newValue in
        #warning("추후 ViewState로 정리")
            if newValue != nil {
                Task {
                    await authManager.getSpeechRecognitionAuthStatus()
                }
            }
        }
        .onChange(of: authManager.isSpeechRecognitionAuthorized) { _, newValue in
            if newValue != nil {
                proceedOnboardingStep()
            }
        }
        .onChange(of: authManager.isLocationAuthorized) { _, newValue in
            if newValue != nil {
                authManager.checkCurrentAuthorizedCondition()
                proceedOnboardingStep()
            }
        }
    }
    
    private func proceedOnboardingStep() {
        switch onboardingStep {
        case .start:
            withAnimation {
                onboardingStep = .conversation(
                    OnboardingInfo(
                        title: NSLocalizedString("마이크와 음성 인식", comment: ""),
                        description: Constants.Onboarding.CONVERSATION,
                        highlightTarget: ["마이크 권한","음성 인식 권한"]
                    )
                )
            }
        case .conversation:
            withAnimation {
                onboardingStep = .location(
                    OnboardingInfo(
                        title: NSLocalizedString("위치", comment: ""),
                        description: Constants.Onboarding.LOCATION,
                        highlightTarget: ["위치 정보 권한","정확한 위치 켬"]
                    )
                )
            }
            
        case .location:
            withAnimation(.spring().speed(0.6)){
                onboardingStep = .complete
            }
            
        case .complete:
            authManager.onOnboardingCompleted()
        }
    }
    
    private func requestAuthorize() {
        Task {
            switch onboardingStep {
            case .conversation:
                if authManager.isMicrophoneAuthorized == nil {
                    await authManager.getMicrophoneAuthStatus()
                } else {
                    proceedOnboardingStep()
                }
                
            case .location:
                if authManager.isLocationAuthorized == nil {
                    await authManager.getLocationAuthStatus()
                } else {
                    proceedOnboardingStep()
                }
                                
            case .complete:
                authManager.onOnboardingCompleted()
                
            default:
                break
            }
        }
    }
    
    @ViewBuilder
    private func eachAuthStatusView() -> some View {
        if let isMicrophoneAuthorized = authManager.isMicrophoneAuthorized,
           let isSpeechRecognitionAuthorized = authManager.isSpeechRecognitionAuthorized,
           let isLocationAuthorized = authManager.isLocationAuthorized {
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
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
                    
                    BDText(text: NSLocalizedString("마이크 권한", comment: ""), style: .H2_SB_135)
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
                    
                    BDText(text: NSLocalizedString("음성 인식 권한", comment: ""), style: .H2_SB_135)
                }
                
                HStack {
                    Image(
                        systemName: isLocationAuthorized
                        ? "checkmark.circle.fill"
                        : "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        isLocationAuthorized
                        ? Color.green
                        : Color.RED
                    )
                    BDText(text: NSLocalizedString("locationPermission", comment:""), style: .H2_SB_135)
                }
                
            }
            
        }
    }
    
    private func onboardingStartGuideView() -> some View {
        VStack(
            alignment: .leading,
            spacing: 52
        ) {
            BDText(text: Constants.Onboarding.GUIDE_MESSAGE, style: .LT_B_160)
                .foregroundStyle(Color.OR6)
            
            Image("bisdam_icon")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
    private func onboardingBottomFooter(info: OnboardingInfo) -> some View {
        VStack(spacing: 24) {
            if onboardingStep != .complete,
               onboardingStep != .start {
                let prompt = NSLocalizedString("onboarding.nextButtonPrompt", comment: "")
                BDText(text: String(format: prompt, info.title), style: .FN_SB_135)
                    .foregroundStyle(Color.OR6)
                    .multilineTextAlignment(.center)
            }
            
            if onboardingStep == .complete,
               !authManager.hasAllAuthBeenObtained {
                BDText(text: Constants.Onboarding.ASK_FOR_AUTH_ALL_GUIDE, style: .H1_B_130)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    
            }
            
            Button {
                if onboardingStep == .start {
                    proceedOnboardingStep()
                    
                } else {
                    requestAuthorize()
                }
                
            } label: {
                BDText(
                    text: onboardingStep == .complete
                       ? NSLocalizedString("startButton", comment:"")
                       : NSLocalizedString("nextButton", comment:""),
                    style: .H1_B_130
                )
                .foregroundStyle(
                    onboardingStep == .complete
                    ? Color.OR6
                    : Color.white
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .padding(.horizontal, 24)
                .background {
                    onboardingStep == .complete
                    ? Color.BaseBGWhite
                    : Color.OR5
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight:
                onboardingStep == .complete
                ? UIScreen.main.bounds.height / 2
                : UIScreen.main.bounds.height / 4,
            alignment: .bottom
        )
        .background(alignment: .bottom) {
            if onboardingStep == .complete {
                ZStack {
                    Circle()
                        .fill(Color.OR5)
                        .opacity(0.1)
                        .frame(width: 930)
                        .aspectRatio(1, contentMode: .fill)
                    
                    Circle()
                        .fill(Color.OR5)
                        .frame(width: 720)
                        .aspectRatio(1, contentMode: .fill)
                        .opacity(0.2)
                        
                    Circle()
                        .fill(Color.OR5)
                        .frame(width: 610)
                        .aspectRatio(1, contentMode: .fill)
                }
                .offset(y: 25)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .opacity
                    )
                )
            }
        }
    }
}

#Preview {
    TKOnboardingView(authManager: .init())
}
