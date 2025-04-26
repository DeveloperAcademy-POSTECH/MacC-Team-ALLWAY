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
   
    let korUrl = URL(
        string: "https://yenchoichoi.notion.site/TALKLAT-fbba4b6204ee4eb9a9681c4d75a673cb?pvs=4"
    )
    
    let foreignUrl = URL(
        string: "https://yenchoichoi.notion.site/BISDAM-Privacy-Policy-d75e2c24b4294c65a30316e2e9a085ae?pvs=4"
    )
    
    let firebaseStore: any TKFirebaseStore = SettingsPersonalInfoFirebaseStore()
    
    var body: some View {
        ZStack {
            if let error = error {
                BDText(
                    text: NSLocalizedString("webView.loading.failure", comment: ""),
                    style: ._20H1_B
                )
                
            } else {
                if Locale.autoupdatingCurrent.identifier == "ko_KR" {
                    if let url = korUrl {
                        WebView(
                            url: url,
                            isLoading: $isLoading,
                            error: $error
                        )
                    }
                } else {
                    if let url = foreignUrl {
                        WebView(
                            url: url,
                            isLoading: $isLoading,
                            error: $error
                        )
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(2)
                }
            }
 
        }
        .onAppear {
            firebaseStore.userDidAction(.viewed)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    firebaseStore.userDidAction(.tapped(.back))
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                        
                        BDText(
                            text: NSLocalizedString("설정", comment: ""),
                            style: ._17H_B
                        )
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                BDText(text: NSLocalizedString("개인정보 처리방침", comment: "")
                       , style: ._17H_B)
            }
        }
    }
}

