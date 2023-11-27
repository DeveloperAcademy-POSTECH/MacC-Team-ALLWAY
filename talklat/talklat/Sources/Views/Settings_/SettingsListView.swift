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
    case gesture = "제스처"
    case dataPolicyInfo = "개인정보 처리방침"
    case creators = "만든 사람들"
    case needHelp = "도움이 필요하신가요?"
    
    var category: String {
        switch self {
        case .textReplacement, .guidingMessage: return "대화"
        case .displayMode: return "접근성"
        // case .haptics: return "일반"
        case .gesture: return "실험실"
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
        case .gesture: return "hands.and.sparkles.fill"
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

struct SettingsListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authManager: TKAuthManager
    @EnvironmentObject private var locationStore: TKLocationStore
    
    private let sectionCategories: [String] = [
        "대화", "접근성", "실험실", "정보", "지원" // TODO: "일반" 추가
    ]
    
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
                    Text(category)
                        .foregroundColor(.GR8)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.leading, 8)
                    
                    // Each Setting Cell
                    ForEach(
                        SectionType.allCases,
                        id: \.rawValue
                    ) { item in
                        if category == item.category {
                            NavigationLink {
                                switch item {
                                case .textReplacement:
                                    TKTextReplacementListView()
                               
                                case .guidingMessage:
                                    SettingsGuidingView()
                                
                                case .displayMode:
                                    SettingsDisplayView()
                                    // SettingsDisplayTestingView()
                                   
                                    /*
                                     case .haptics:
                                         SettingsHapticView()
                                     */
                                    
                                case .gesture:
                                    SettingsGestureView()
                                    
                                case .dataPolicyInfo:
                                    LoadingWebView()
                                    
                                case .creators:
                                    SettingsTeamView()
                               
                                case .needHelp:
                                    SettingsHelpView()
                                }
                            } label: {
                                BDListCell(label: item.rawValue) {
                                    Image(systemName: item.icon)
                                } trailingUI: {
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                }
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: locationStore(\.authorizationStatus), { oldValue, newValue in
            switch newValue {
            case .authorizedAlways, .authorizedWhenInUse:
                authManager.isLocationAuthorized = true
            default:
                authManager.isLocationAuthorized = false
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        Text("홈")
                    }
                    .foregroundColor(Color.OR6)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

@ViewBuilder
func authNoticeBuilder(noticeItem: AuthorizationType) -> some View {
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
                Text("\(noticeItem.rawValue) 권한이 꺼져있어요.")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
                
                HStack {
                    Text("권한 허용하러 가기")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .bold))
                    
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
}

#Preview {
    NavigationStack {
        SettingsListView()
    }
}
