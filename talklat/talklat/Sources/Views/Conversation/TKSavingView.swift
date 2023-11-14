//
//  TKSavingView.swift
//  talklat
//
//  Created by Celan on 11/11/23.
//

import SwiftUI

struct TKSavingView: View {
    // MARK: - TKLocation Manager, TKConversation Manager Here
    @ObservedObject var store: TKConversationViewStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack {
                Button {
                    store.onDismissSavingViewButtonTapped()
                } label: {
                    Text("취소")
                }
                
                Spacer()
                
                Text("새 대화 저장")
                
                Spacer()
                
                Button {
                    #warning("Create TKConverstion + TKLocation")
                    store.onSaveNewConversationButtonTapped()
                } label: {
                    Text("저장")
                }
            }
            .font(.headline)
            .bold()
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            Text("제목")
                .font(.headline)
                .padding(.leading, 32)
                .padding(.bottom, 8)
                .foregroundStyle(Color.gray500)
            
            HStack {
                TextField("", text: .constant("토크랫(5)"))
                    .font(.headline)
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                
                Spacer()
                
                Button {
                    #warning("xmarkButton")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 16)
            }
            .background {
                Capsule()
                    .fill(Color.gray100)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            Text("10/20")
                .font(.footnote)
                .padding(.leading, 32)
                .foregroundStyle(Color.gray400)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 26)
        .overlay(alignment: .top) {
            Capsule()
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .foregroundStyle(Color.gray300)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    Color.black
        .sheet(
            isPresented: .constant(true)
        ) {
            TKSavingView(store: .init())
        }
}
