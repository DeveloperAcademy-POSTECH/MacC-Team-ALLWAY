//
//  SettingsListView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/13/23.
//

import SwiftUI

enum SectionTypes: String, CaseIterable
{
    case textReplacement = "텍스트 대치"
    case guidingMessage = "안내 문구"
    case displayMode = "화면 모드"
    case haptics = "진동"
    case gesture = "제스처"
    case appServiceInfo = "앱 및 서비스 정보"
    case creators = "만든 사람들"
    case needHelp = "도움이 필요하신가요?"
    case onBoarding = "온보딩 설명 다시 보기"
    
    var category: String
    {
        switch self {
        case .textReplacement, .guidingMessage: return "대화"
        case .displayMode: return "접근성"
        case .haptics: return "일반"
        case .gesture: return "실험실"
        case .appServiceInfo, .creators: return "정보"
        case .needHelp, .onBoarding: return "지원"
        }
    }
    
    var icon: String
    {
        switch self {
        case .textReplacement: return "bubble.left.and.text.bubble.right.fill"
        case .guidingMessage: return "quote.opening"
        case .displayMode: return "sun.max.fill"
        case .haptics: return "water.waves"
        case .gesture: return "hands.and.sparkles.fill"
        case .appServiceInfo: return "app.badge.fill"
        case .creators: return "person.2.fill"
        case .needHelp: return "person.crop.circle.fill.badge.questionmark"
        case .onBoarding: return "lightbulb.max.fill"
        }
    }
}

struct SettingsListView: View {
    var sectionCategories: [String] = [
        "대화", "접근성", "일반", "실험실", "정보", "지원"
    ]
    
    var body: some View {
        ScrollView {
            ForEach(sectionCategories, id: \.self) { category in
                VStack(alignment: .leading) {
                    Text(category)
                        .foregroundColor(.gray800)
                        .font(.system(size: 20, weight: .bold))
                    
                    // Each Setting Cell
                    ForEach(SectionTypes.allCases, id: \.rawValue) { item in
                        if category == item.category {
                            SettingItem(item: item)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("설정")
        .scrollIndicators(.hidden)
    }
}

struct SettingItem: View {
    var item: SectionTypes
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .font(.system(size: 15))
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.rawValue)
                    .font(.system(size: 17, weight: .medium))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 19)
        .padding(.horizontal, 20)
        .background(Color.gray100)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsListView()
}
