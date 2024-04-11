//
//  SettingsListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/13/23.
//

import SwiftUI

private enum SectionType: String, CaseIterable {
    case textReplacement = "텍스트 대치"
    case guidingMessage = "안내 문구"
    case displayMode = "화면 모드"
    // case haptics = "진동"
//    case gesture = "제스처"
    case dataPolicyInfo = "개인정보 처리방침"
    case creators = "만든 사람들"
    case needHelp = "도움이 필요하신가요?"
    
    var category: String {
        switch self {
        case .textReplacement, .guidingMessage: return "대화"
        case .displayMode: return "접근성"
        // case .haptics: return "일반"
//        case .gesture: return "실험실"
        case .dataPolicyInfo, .creators: return "정보"
        case .needHelp: return "지원"
        }
    }
    
    var icon: String {
        switch self {
        case .textReplacement: return "bubble.left.and.text.bubble.right.fill"
        case .guidingMessage: return "quote.opening"
        case .displayMode: return "sun.max.fill"
        // case .haptics: return "water.waves"
//        case .gesture: return "hands.and.sparkles.fill"
        case .dataPolicyInfo: return "app.badge.fill"
        case .creators: return "person.2.fill"
        case .needHelp: return "person.crop.circle.fill.badge.questionmark"
        }
    }
}

internal enum AuthorizationType: String {
    case micAndSpeech = "마이크 및 음성인식"
    case location = "위치"
    
    var icon: String {
        switch self {
        case .micAndSpeech: return "mic.slash.circle.fill"
        case .location: return "location.slash.circle.fill"
        }
    }
}

struct SettingsListView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authManager: TKAuthManager
    @EnvironmentObject private var locationStore: TKLocationStore
    
    private let sectionCategories: [String] = [
        "대화", "접근성", /* "실험실", */ "정보", "지원" // TODO: "일반" 추가
    ]
    
    let firebaseStore: any TKFirebaseStore = SettingsFirebaseStore()
    
    var body: some View {
        ScrollView {
            VStack {
                if let isMicAuthorized = authManager.isMicrophoneAuthorized,
                   let isSpeechAuthorized = authManager.isSpeechRecognitionAuthorized {
                    if !isMicAuthorized || !isSpeechAuthorized {
                        authNoticeBuilder(noticeItem: AuthorizationType.micAndSpeech)
                    }
                }
                
                if let isLocationAuthorized = authManager.isLocationAuthorized {
                    if !isLocationAuthorized {
                        authNoticeBuilder(noticeItem: AuthorizationType.location)
                    }
                }
            }
            .padding(.top, 10)
            .padding(
                .bottom,
                authManager.hasAllAuthBeenObtained ? 0 : 24
            )
            
            ForEach(
                sectionCategories,
                id: \.self
            ) { category in
                VStack(alignment: .leading) {
                    BDText(text: category, style: .H1_B_130)
                        .foregroundColor(.GR8)
                        .padding(.leading, 8)
                    
                    // Each Setting Cell
                    ForEach(
                        SectionType.allCases,
                        id: \.rawValue
                    ) { item in
                        if category == item.category {
                            Group {
                                NavigationLink {
                                    switch item {
                                    case .textReplacement:
                                        TKTextReplacementListView()
                                            .navigationBarBackButtonHidden()
                                        
                                    case .guidingMessage:
                                        SettingsGuidingView()
                                            .navigationBarBackButtonHidden()
                                        
                                    case .displayMode:
                                        SettingsDisplayView()
                                            .navigationBarBackButtonHidden()
                                        
                                    case .dataPolicyInfo:
                                        LoadingWebView()
                                            .navigationBarBackButtonHidden()
                                        
                                    case .creators:
                                        SettingsTeamView()
                                            .navigationBarBackButtonHidden()
                                        
                                    case .needHelp:
                                        SettingsHelpView()
                                            .navigationBarBackButtonHidden()
                                    }
                                } label: {
                                    BDListCell(label: item.rawValue) {
                                        Image(systemName: item.icon)
                                    } trailingUI: {
                                        Image(systemName: "chevron.right")
                                    }
                                }
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        switch item {
                                        case .textReplacement:
                                            firebaseStore.userDidAction(.tapped(.textReplace))
                                        case .guidingMessage:
                                            firebaseStore.userDidAction(.tapped(.guideMessage))
                                        case .displayMode:
                                            firebaseStore.userDidAction(.tapped(.displayMode))
                                        case .dataPolicyInfo:
                                            firebaseStore.userDidAction(.tapped(.personalInfo))
                                        case .creators:
                                            firebaseStore.userDidAction(.tapped(.makers))
                                        case .needHelp:
                                            firebaseStore.userDidAction(.tapped(.help))
                                        }
                                    }
                            )
                        }
                    }
                }
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            firebaseStore.userDidAction(.viewed)
            switch locationStore(\.authorizationStatus) {
            case .authorizedAlways, .authorizedWhenInUse:
                authManager.isLocationAuthorized = true
            default:
                authManager.isLocationAuthorized = false
            }
        }
        .onChange(of: locationStore(\.authorizationStatus)) { _, newValue in
            switch newValue {
            case .authorizedAlways, .authorizedWhenInUse:
                firebaseStore.userDidAction(.tapped(.locationPermit))
                authManager.isLocationAuthorized = true
            default:
                authManager.isLocationAuthorized = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    firebaseStore.userDidAction(.tapped(.back))
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "홈",
                            style: .H1_B_130
                        )
                    }
                    .foregroundColor(Color.OR6)
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(
                    text: "설정",
                    style: .H1_B_130
                )
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func authNoticeBuilder(noticeItem: AuthorizationType) -> some View {
        Button {
            if let url = URL(
                string: UIApplication.openSettingsURLString
            ) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Image(systemName: noticeItem.icon)
                    .foregroundColor(.white)
                    .font(.system(size: 45))
                
                VStack(alignment: .leading, spacing: 8) {
                    BDText(text: "\(noticeItem.rawValue) 권한이 꺼져있어요.", style: .H1_B_130)
                        .foregroundColor(.white)
                    
                    HStack {
                        BDText(text: "권한 허용하러 가기", style: .H1_B_130)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.up.forward.app.fill")
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
            .foregroundColor(Color.BaseBGWhite)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.OR5)
            .cornerRadius(22)
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    switch noticeItem {
                    case .micAndSpeech:
                        firebaseStore.userDidAction(.tapped(.speechPermit))
                    case .location:
                        firebaseStore.userDidAction(.tapped(.locationPermit))
                    }
                }
        )
    }
}

#Preview {
    NavigationStack {
        SettingsListView()
    }
}
