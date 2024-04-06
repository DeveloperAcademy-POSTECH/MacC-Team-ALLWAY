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
                    BDText(
                        text: NSLocalizedString("creators.description", comment: ""),
                        style: .H1_B_160
                    )
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
                            BDText(
                                text: NSLocalizedString("lets.sentence", comment: ""),
                                style: .FN_SB_135
                            )
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
                
                TeamOneView(
                    emoji: "🐠",
                    name: "리앤 Lianne",
                    jobTitle: "iOS Developer",
                    customMessage: NSLocalizedString("lianne.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(
                    emoji: "🥐",
                    name: "매들린 Madeline",
                    jobTitle: "iOS Developer",
                    customMessage: NSLocalizedString("madeline.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(
                    emoji: "🌏",
                    name: "지구 Jigu",
                    jobTitle: "Product Manager",
                    customMessage: NSLocalizedString("jigu.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(
                    emoji: "🍋",
                    name: "린 Reene",
                    jobTitle: "Product Manager",
                    customMessage: NSLocalizedString("reene.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(
                    emoji: "👃🏻",
                    name: "코비 Koby",
                    jobTitle: "UXUI Designer",
                    customMessage: NSLocalizedString("koby.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                TeamOneView(
                    emoji: "☕️",
                    name: "모카 Moca",
                    jobTitle: "UXUI Designer",
                    customMessage: NSLocalizedString("moca.sentence", comment: "")
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: NSLocalizedString("설정", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    .tint(Color.OR5)
                }
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                BDText(
                    text: NSLocalizedString("creators.title", comment: ""),
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
