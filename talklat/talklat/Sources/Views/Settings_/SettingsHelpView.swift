//
//  SettingsHelpView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/15/23.
//

import SwiftUI
import UIKit
import MessageUI

struct SettingsHelpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEmailShowing: Bool = false
    @State private var emailResult: Result<MFMailComposeResult, Error>?
    
    var body: some View {
        VStack {
            BDListCell(label: "문의 및 오류 신고하기") {
            } trailingUI: {
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                isEmailShowing = true
            }
            
            Spacer()
        }
        .navigationTitle("도움이 필요하신가요?")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        Text("설정")
                            .font(.system(size: 17))
                    }
                    .tint(Color.OR5)
                }
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .sheet(isPresented: $isEmailShowing) {
            EmailView(
                isShowing: $isEmailShowing,
                result: $emailResult
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsHelpView()
}
