//
//  SettingsListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/13/23.
//

import SwiftUI

private enum SectionType: String, CaseIterable {
    case textReplacement
    case guidingMessage
    case displayMode
    // case haptics = "진동"
//    case gesture = "제스처"
    case dataPolicyInfo
    case creators
    case needHelp
    
    var title: String {
        switch self {
        case .textReplacement: return NSLocalizedString("textReplacement.title", comment: "")
        case .guidingMessage: return NSLocalizedString("guidingMessage.title", comment: "")
        case .displayMode: return NSLocalizedString("displayMode.title", comment: "")
        case .dataPolicyInfo: return NSLocalizedString("dataPolicyInfo.title", comment: "")
        case .creators: return NSLocalizedString("creators.title", comment: "")
        case .needHelp: return NSLocalizedString("needHelp.title", comment: "")
        }
    }
    
    var category: String {
        switch self {
        case .textReplacement, .guidingMessage: return NSLocalizedString("대화", comment: "")
        case .displayMode: return NSLocalizedString("접근성", comment: "")
        // case .haptics: return "일반"
//        case .gesture: return "실험실"
        case .dataPolicyInfo, .creators: return NSLocalizedString("정보", comment: "")
        case .needHelp: return NSLocalizedString("지원", comment: "")
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
    case micAndSpeech
    case location
    
    var title: String {
        switch self {
        case .micAndSpeech: return NSLocalizedString("마이크와 음성 인식", comment: "")
        case .location: return NSLocalizedString("위치", comment: "")
        }
    }
    
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
        NSLocalizedString("대화", comment: ""),
        NSLocalizedString("접근성", comment: ""),
        /* "실험실", */
        NSLocalizedString("정보", comment: ""), 
        NSLocalizedString("지원", comment: "")
        /* "일반", */
    ]
    
    let firebaseStore: any TKFirebaseStore = SettingsFirebaseStore()
    
    var body: some View {
        ScrollView {
            if let isMicAuthorized = authManager.isMicrophoneAuthorized,
               let isSpeechAuthorized = authManager.isSpeechRecognitionAuthorized {
                if !isMicAuthorized || !isSpeechAuthorized {
                    authNoticeBuilder(noticeItem: AuthorizationType.micAndSpeech)
                        .padding(.top, 10)
                }
            }
            
            if let isLocationAuthorized = authManager.isLocationAuthorized {
                if !isLocationAuthorized {
                    authNoticeBuilder(noticeItem: AuthorizationType.location)
                        .padding(.top, 10)
                }
            }
            
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
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
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
                            text: NSLocalizedString("home.title", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    .foregroundColor(Color.OR6)
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(
                    text: NSLocalizedString("설정", comment: ""),
                    style: .H1_B_130
                )
            }
        }
        .background(Color.ExceptionWhiteW8)
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
                    BDText(
                        text: "\(noticeItem.title) \(NSLocalizedString("permission.denied", comment: ""))",
                        style: .H1_B_130
                    )
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    
                    HStack {
                        BDText(
                            text: NSLocalizedString("permission.settings", comment: ""),
                            style: .H1_B_130
                        )
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        
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
            .environmentObject(TKAuthManager())
            .environmentObject(TKLocationStore())
    }
}
