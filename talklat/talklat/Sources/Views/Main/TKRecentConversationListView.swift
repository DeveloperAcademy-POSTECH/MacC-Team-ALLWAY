//
//  TKRecentConversationListView.swift
//  talklat
//
//  Created by Celan on 11/8/23.
//

import SwiftUI

struct TKRecentConversationListView: View {
    let conversation = TKConversation(title: "Hi", createdAt: Date.now, content: [TKContent]())
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    
                    Text("내 근처 대화 목록")
                        .font(.title3)
                        .bold()
                }
                .foregroundStyle(Color.GR5)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 32)
            .padding(.bottom, 16)
            
            ScrollView {
                #warning("CONVERSATION LIST COUNT")
                ForEach(0..<10) { _ in
                    NavigationLink {
                        CustomHistoryView(
                            historyViewType: .item, 
                            conversation: conversation
                        )
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("메가커피")
                                    .foregroundStyle(Color.GR8)
                                    .bold()
                                
                                Text("20m")
                                    .font(.footnote)
                                    .foregroundStyle(Color.OR6)
                            }
                            
                            HStack {
                                Text("2023.10.29(일)")
                                    .font(.footnote)
                                    .foregroundStyle(Color.GR4)
                                
                                Spacer()
                                
                                Group {
                                    Text("대화하기")
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.GR7)
                            }
                            
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.GR1)
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
