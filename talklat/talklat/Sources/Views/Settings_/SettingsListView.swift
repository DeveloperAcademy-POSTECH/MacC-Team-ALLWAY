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
    // case displayMode = "화면 모드"
    // case haptics = "진동"
    // case gesture = "제스처"
    // case appServiceInfo = "앱 및 서비스 정보"
    case dataPolicyInfo = "개인정보 처리방침"
    case creators = "만든 사람들"
    case needHelp = "도움이 필요하신가요?"
    
    var category: String {
        switch self {
        case .textReplacement, .guidingMessage: return "대화"
        // case .displayMode: return "접근성"
        // case .haptics: return "일반"
        // case .gesture: return "실험실"
        // .appServiceInfo -> .dataPolicyInfo
        case .dataPolicyInfo, .creators: return "정보"
        case .needHelp: return "지원"
        }
    }
    
    var icon: String {
        switch self {
        case .textReplacement: return "bubble.left.and.text.bubble.right.fill"
        case .guidingMessage: return "quote.opening"
        // case .displayMode: return "sun.max.fill"
        // case .haptics: return "water.waves"
        // case .gesture: return "hands.and.sparkles.fill"
        // case .appServiceInfo: return "app.badge.fill"
        case .dataPolicyInfo: return "app.badge.fill"
        case .creators: return "person.2.fill"
        case .needHelp: return "person.crop.circle.fill.badge.questionmark"
        }
    }
}

struct SettingsListView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var authStatus: AuthStatus = .authCompleted
    
    private let sectionCategories: [String] = [
        "대화", "정보", "지원" // TODO: - "접근성", "일반", "실험실" 추가
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // TODO: appRootManager.switchAuthStatus에서 분기처리 변경 (위치 권한 분기 추가)
                switch authStatus {
                case .microphoneAuthIncompleted, .speechRecognitionAuthIncompleted:
                    authNoticeBuilder(noticeItem: "마이크와 음성인식")
                
                    // TODO: case .locationAuthIncompleted:
                    // authNoticeBuilder(noticeItem: "위치")
                    
                case .authIncompleted:
                    authNoticeBuilder(noticeItem: "마이크와 음성인식")
                    authNoticeBuilder(noticeItem: "위치")
                    
                default:
                    Color.clear
                        .frame(height: 0)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, authStatus == .authCompleted ? 0 : 24)
            
            ForEach(sectionCategories, id: \.self) { category in
                VStack(alignment: .leading) {
                    Text(category)
                        .foregroundColor(.GR8)
                        .font(.system(size: 20, weight: .bold))
                    
                    // Each Setting Cell
                    ForEach(SectionType.allCases, id: \.rawValue) { item in
                        if category == item.category {
                            NavigationLink {
                                switch item {
                                case .textReplacement:
                                    TKTextReplacementListView()
                               
                                case .guidingMessage:
                                    SettingsGuidingView()
                                
                                    /*
                                     case .displayMode:
                                         SettingsDisplayView(
                                             settingViewStore: settingViewStore
                                         )
                                    
                                     case .haptics:
                                         SettingsHapticView(
                                             settingViewStore: settingViewStore
                                         )
                                     
                                     case .gesture:
                                         SettingsGestureView(
                                             settingViewStore: settingViewStore
                                         )
                                     */
                                    
                                case .dataPolicyInfo:
                                    LoadingWebView()
                                    
                                case .creators:
                                    EmptyView()
                               
                                case .needHelp:
                                    SettingsHelpView()
                                }
                            } label: {
                                TKListCell(label: item.rawValue) {
                                    Image(systemName: item.icon)
                                } trailingUI: {
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("홈")
                    }
                    .foregroundColor(Color.OR6)
                }
            }
        }
        .scrollIndicators(.hidden)
        .task {
            await authStatus = SpeechAuthManager.switchAuthStatus()
        }
    }
}

@ViewBuilder
func authNoticeBuilder(noticeItem: String) -> some View {
    HStack {
        if noticeItem == "마이크와 음성인식" {
            Image(systemName: "mic.slash.circle.fill")
                .font(.system(size: 40))
        } else if noticeItem == "위치" {
            Image(systemName: "location.slash.circle.fill")
                .font(.system(size: 40))
        }
        
        VStack(alignment: .leading, spacing: 10) {
            Text("\(noticeItem) 권한이 꺼져있어요.")
                .font(.system(size: 17, weight: .bold))
            
            HStack {
                Text("권한 허용하러 가기")
                    .font(.system(size: 17, weight: .medium))
                
                Image(systemName: "arrow.up.forward.app.fill")
            }
        }
        
        Spacer()
    }
    .foregroundColor(Color.BaseBGWhite)
    .frame(maxWidth: .infinity)
    .padding(20)
    .background(Color.OR5)
    .cornerRadius(22)
}

#Preview {
    NavigationStack {
        SettingsListView()
    }
}
