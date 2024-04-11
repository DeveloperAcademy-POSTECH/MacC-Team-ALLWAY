//
//  LoadingWebView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/16/23.
//

import SwiftUI

struct LoadingWebView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = true
    @State private var error: Error? = nil
    let url = URL(string: "https://yenchoichoi.notion.site/TALKLAT-fbba4b6204ee4eb9a9681c4d75a673cb?pvs=4")
    
    let firebaseStore: any TKFirebaseStore = SettingsPersonalInfoFirebaseStore()
    
    var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.pink)
            } else if let url = url {
                WebView(
                    url: url,
                    isLoading: $isLoading,
                    error: $error
                )
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(2)
                }
            } else {
                Text("Sorry, we could not load this url.")
            }
 
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
//                    firebaseStore.userDidAction(
//                        .tapped,
//                        "back",
//                        nil
//                    )
                    firebaseStore.userDidAction(.tapped(.back))
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: "설정",
                            style: .H1_B_130
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: "개인정보 처리방침", style: .H1_B_130)
            }
        }
    }
}

