//
//  TKRecentConversationListView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKRecentConversationListView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("내 근처 대화 목록")
                    .font(.title3)
                    .bold()
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 32)
            
            ScrollView {
                #warning("CONVERSATION LIST COUNT")
                ForEach(0..<10) { _ in
                    NavigationLink {
                        Text("?")
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("메가커피")
                                    .foregroundStyle(Color.primary)
                                    .bold()
                                
                                Text("20m")
                                    .font(.footnote)
                            }
                            
                            HStack {
                                Text("2023.10.29(일)")
                                    .font(.footnote)
                                    .foregroundStyle(Color.gray400)
                                
                                Spacer()
                                
                                Group {
                                    Text("대화하기")
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.gray700)
                            }
                            
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    TKRecentConversationListView()
}
