//
//  SettingsTeamView.swift
//  talklat
//
//  Created by 신정연 on 11/16/23.
//

import SwiftUI

struct SettingsTeamView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(colorScheme == .light ? "TeamLogo" : "TeamLogo_Dark")
                    Spacer()
                }
                .padding(.leading, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
                HStack {
                    BDText(text: "애플 디벨로퍼 아카데미 수료생으로 구성된\nALLWAY(올해의 팀) 팀은 사회의 다양한 문제를\n탐구하고 분석하여 문제 해결을 위한 기술 서비스를\n기획 및 제작하고 있습니다.", style: .H1_B_160)
                        .foregroundStyle(Color.GR9)
                    
                    Spacer()
                }
                .padding(.leading, 24)
                .padding(.bottom, 50)
                
                TeamOneView(emoji: "🌿", name: "첼란 Celan", jobTitle: "iOS Developer", customMessage: "EXC_BAD_ACCESS")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                HStack(spacing: 0) {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.AlertBGWhite)
                        .overlay {
                            Text("🙃")
                                .font(.largeTitle)
                        }
                    VStack {
                        HStack {
                            BDText(text: "레츠 Lets", style: .H1_B_130)
                                .foregroundStyle(Color.GR9)
                            Spacer()
                        }
                        HStack {
                            BDText(text: "iOS Developer", style: .FN_SB_135)
                                .foregroundStyle(Color.GR5)
                            Spacer()
                        }
                        HStack {
                            BDText(text: "안녕하세요 천재 개(발자) 레츠입니다 :)", style: .FN_SB_135)
                                .rotationEffect(Angle(degrees: 180))
                                .foregroundStyle(Color.GR5)
                            Spacer()
                        }
                    }
                    .padding(.leading, 12)
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.leading, 16)
                .background(Color.GR1)
                .cornerRadius(22)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(emoji: "🐠", name: "리앤 Lianne", jobTitle: "iOS Developer", customMessage: "버그를 잡았는데요, 안잡혔습니다.")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                TeamOneView(emoji: "🥐", name: "매들린 Madeline", jobTitle: "iOS Developer", customMessage: "do { try 행복 } catch { 야근 }")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                TeamOneView(emoji: "🌏", name: "지구 Jigu", jobTitle: "Product Manager", customMessage: "방금 얘기한 내용 노션에 정리되어있습니다~! :)")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                TeamOneView(emoji: "🍋", name: "린 Reene", jobTitle: "Product Manager", customMessage: "호방하지만 기품있는 외조담당")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                TeamOneView(emoji: "👃🏻", name: "코비 Koby", jobTitle: "UXUI Designer", customMessage: "좋은 제품을 잘 만들고 싶은 디자이너")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                TeamOneView(emoji: "☕️", name: "모카 Moca", jobTitle: "UXUI Designer", customMessage: "우주? 아~ 제가 발로 밟고 있는거요?")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "설정",
                            style: .H1_B_130
                        )
                    }
                    .tint(Color.OR5)
                }
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: "만든 사람들",
                    style: .H1_B_130
                )
            }
        }
    }
}


struct TeamOneView: View {
    var emoji: String
    var name: String
    var jobTitle: String
    var customMessage: String
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.AlertBGWhite)
                .overlay {
                    Text(emoji)
                        .font(.largeTitle)
                }
            VStack {
                HStack {
                    BDText(text: name, style: .H1_B_130)
                        .foregroundStyle(Color.GR9)
                    Spacer()
                }
                HStack {
                    BDText(text: jobTitle, style: .FN_SB_135)
                        .foregroundStyle(Color.GR5)
                    Spacer()
                }
                HStack {
                    BDText(text: customMessage, style: .FN_SB_135)
                        .foregroundStyle(Color.GR5)
                    Spacer()
                }
            }
            .padding(.leading, 12)
            
            Spacer()
            
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .background(Color.GR1)
        .cornerRadius(22)
    }
}
