//
//  LoadingWebView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/16/23.
//

import SwiftUI

struct LoadingWebView: View {
    @State private var isLoading = true
    @State private var error: Error? = nil
    let url = URL(string: "https://yenchoichoi.notion.site/TALKLAT-fbba4b6204ee4eb9a9681c4d75a673cb?pvs=4")
    
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
    }
}

