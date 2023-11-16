//
//  SettingsTeamView.swift
//  talklat
//
//  Created by 신정연 on 11/16/23.
//

import SwiftUI

struct SettingsTeamView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image("TeamLogo")
                        Spacer()
                    }
                    .padding(.leading, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    HStack {
                        Text("올웨이팀은 어쩌구저쩌구 입니다.\n어쩌구저쩌구해서 머하는 팀입니다.")
                            .font(.system(size: 17, weight: .bold))
                            .lineSpacing(17 * 1.6 - 17)
                            .padding(.vertical, (17 * 1.6 - 17) / 2)
                        
                        Spacer()
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 50)
                    
                    TeamOneView(emoji: "🌿", name: "첼란 Celan", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "🙃", name: "레츠 Lets", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "🐠", name: "리앤 Lianne", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "🥐", name: "매들린 Madeline", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "🌏", name: "지구 Jigu", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "🍋", name: "린 Reene", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "👃🏻", name: "코비 Koby", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    TeamOneView(emoji: "☕️", name: "모카 Moca", jobTitle: "iOS Developer", customMessage: "첼란이 하고 싶은 말")
                    
                }
            }
            .navigationTitle("만든 사람들")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TeamOneView: View {
    var emoji: String
    var name: String
    var jobTitle: String
    var customMessage: String
    var body: some View {
        HStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.BaseBGWhite)
                .overlay {
                    Text(emoji)
                        .font(.largeTitle)
                }
            VStack {
                HStack {
                    Text(name)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(Color.GR9)
                    Spacer()
                }
                HStack {
                    Text(jobTitle)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.GR5)
                    Spacer()
                }
                HStack {
                    Text(customMessage)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.GR5)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .background(Color.GR1)
        .cornerRadius(22)
    }
}

#Preview {
    SettingsTeamView()
}
