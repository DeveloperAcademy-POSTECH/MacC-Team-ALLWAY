//
//  TKOnboardingView.swift
//  talklat
//
//  Created by Celan on 11/16/23.
//

import SwiftUI

struct TKOnboardingView: View {
    struct OnboardingInfo: Equatable {
        var step: Int
        var title: String
        var description: String
    }
    
    enum OnboardingStep: Equatable {
        case start
        case mic(OnboardingInfo)
        case speech(OnboardingInfo)
        case location(OnboardingInfo)
        case complete
    }
    
    @State private var onboardingStep: OnboardingStep = .start
    @State private var onboardInfo: OnboardingInfo = OnboardingInfo(
        step: 0,
        title: "",
        description: ""
    )
    
    var body: some View {
        VStack {
            if case .start = onboardingStep {
                onboardingStartGuideView()
            }
            
            if case let .mic(info) = onboardingStep {
                TKRequestAuthorizationView(
                    parentInfo: $onboardInfo,
                    info: info
                )
            }
            
            if case let .speech(info) = onboardingStep {
                TKRequestAuthorizationView(
                    parentInfo: $onboardInfo,
                    info: info
                )
            }
            
            if case let .location(info) = onboardingStep {
                TKRequestAuthorizationView(
                    parentInfo: $onboardInfo,
                    info: info
                )
            }
            
            if case .complete = onboardingStep {
                VStack {
                    // MARK: CONDITION
                    Text(Constants.Onboarding.ALL_AUTH)
                        .font(.largeTitle)
                        .bold()
                        .lineSpacing(17)
                        .foregroundStyle(Color.OR6)
                    
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            onboardingBottomFooter(info: onboardInfo)
        }
    }
    
    private func routeOnboarding() {
        switch onboardingStep {
        case .start:
            withAnimation {
                onboardingStep = .mic(
                    OnboardingInfo(
                        step: 0,
                        title: "마이크",
                        description: Constants.Onboarding.MIC
                    )
                )
            }
        case .mic:
            withAnimation {
                onboardingStep = .speech(
                    OnboardingInfo(
                        step: 1,
                        title: "음성 인식",
                        description: Constants.Onboarding.SPEECH
                    )
                )
            }
        case .speech:
            withAnimation {
                onboardingStep = .location(
                    OnboardingInfo(
                        step: 2,
                        title: "위치",
                        description: Constants.Onboarding.LOCATION
                    )
                )
            }
        case .location:
            withAnimation(.spring().speed(0.6)){
                onboardingStep = .complete
            }
            
        case .complete:
            withAnimation(.spring().speed(0.6)){
                onboardingStep = .start
            }
        }
    }
    
    private func onboardingStartGuideView() -> some View {
        VStack(
            alignment: .leading,
            spacing: 52
        ) {
            Text(Constants.Onboarding.GUIDE_MESSAGE)
                .font(.largeTitle)
                .bold()
                .lineSpacing(17)
                .foregroundStyle(Color.OR6)
            
            Image("TALKALT_BUBBLES_MARK")
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
                Group {
                    HStack {
                        ForEach(0..<3) { idx in
                            Circle()
                                .fill(
                                    idx == info.step
                                    ? Color.OR6
                                    : Color.GR2
                                )
                                .frame(width: 12)
                        }
                    }
                    
                    Text("다음 버튼을 누르고\n\(info.title) 권한을 허용해 주세요.")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.OR6)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button {
                routeOnboarding()
                
            } label: {
                Text(
                    onboardingStep == .complete
                    ? "시작하기"
                    : "다음"
                )
                .font(.headline)
                .bold()
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
    TKOnboardingView()
}

struct TKRequestAuthorizationView: View {
    @Binding var parentInfo: TKOnboardingView.OnboardingInfo
    let info: TKOnboardingView.OnboardingInfo
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack(spacing: 15) {
                Circle()
                    .frame(width: 34, height: 34)
                    
                Text("\(info.title).")
                    .font(.largeTitle)
                    .bold()
            }
            .foregroundStyle(Color.OR6)
            .padding(.bottom, 36)
            
            Text("\(info.description)")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
                .lineSpacing(16)
            
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .transition(
            .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        )
        .onAppear {
            self.parentInfo = info
        }
    }
}
