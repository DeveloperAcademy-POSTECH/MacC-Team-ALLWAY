//
//  SheetWebView.swift
//  talklat
//
//  Created by user on 11/12/23.
//

import SwiftUI
import WebKit

struct SheetWebView: UIViewRepresentable {
    @Binding var webURL: URL?
    let webView: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = webURL else {
            webView.load(URLRequest(url: URL(string: "https://google.com")!))
            return webView
        }
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

