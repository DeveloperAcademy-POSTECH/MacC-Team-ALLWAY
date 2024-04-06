//
//  TKToast.swift
//  talklat
//
//  Created by Celan on 11/14/23.
//

import SwiftData
import SwiftUI

struct TKToast: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    let title: String
    let locationInfo: String
    
    // 유저의 시스템 언어
    var userPreferredLanguage: String {
        return Locale.preferredLanguages.first ?? "Language preference not found"
    }

    var body: some View {
        if isPresented {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.white,
                        Color.OR5
                    )
                    .padding(.leading, 16)
                
                VStack(alignment: .leading) {
                    BDText(text: title, style: .H2_SB_135)
                        .foregroundStyle(Color.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                        
                        if userPreferredLanguage == "en" {
                            let _ = print("preferred Language: ", userPreferredLanguage)
                            Text(NSLocalizedString("location.saved.message", comment: ""))
                            +
                            Text("\(locationInfo)")
                            
                        } else if userPreferredLanguage == "ko" {
                            Text("\(locationInfo)")
                            +
                            Text(NSLocalizedString("location.saved.message", comment: ""))
                            
                        } else {
                            Text("대화가 저장되었어요.")
                        }
                    }
                    .onAppear {
                        print("locale: ", userPreferredLanguage)
                    }
                    .font(.caption2)
                    .foregroundStyle(colorScheme == .light ? Color.GR4 : Color.GR6)
                }
            }
            .padding(.horizontal, 16)
            .frame(
                maxWidth: .infinity,
                maxHeight: 65,
                alignment: .leading
            )
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(colorScheme == .light ? Color.GR7 : Color.GR3)
                    .padding(.horizontal, 16)
            }
            .transition(
                .move(edge: .top)
                .combined(with: .opacity)
            )
            .onTapGesture {
                dismissToast()
            }
            .task {
                try? await Task.sleep(for: .seconds(2.5))
                dismissToast()
            }
        }
    }
    
    private func dismissToast() {
        withAnimation {
            if isPresented {
                isPresented = false
            }
        }
    }
}

#Preview {
    TKToast(
        isPresented: .constant(false),
        title: "TITLE",
        locationInfo: "LOCATION"
    )
}
