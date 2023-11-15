//
//  SettingsAppInfoView.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/14/23.
//

import SwiftUI
import WebKit

struct SettingsAppInfoView: View {
    @State private var isLoading: Bool = true
    
    enum AppInfoType: String, CaseIterable {
        case versionInfo =  "업데이트 내역"
        // case copyrightInfo = "저작권 및 이용약관"
        case dataPolicyInfo = "개인정보 처리방침"
        
        var infoURL: URL {
            var urlAddress: URL = URL(
                string: ""
            ) ?? URL(string: "www.google.com")! 
            
            switch self {
            case .versionInfo:
                if let url = URL(string: "https://www.apple.com") {
                    urlAddress = url
                }
                
                /*
                 case .copyrightInfo:
                     if let url = URL(string: "https://www.apple.com") {
                         urlAddress = url
                     }
                 */
                
            case .dataPolicyInfo:
                if let url = URL(string: "https://yenchoichoi.notion.site/TALKLAT-fbba4b6204ee4eb9a9681c4d75a673cb?pvs=4") {
                    urlAddress = url
                }
            }
            
            return urlAddress
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                VStack(spacing: 4) {
                    Image("logoIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 109)
                    
                    Text("TALKLAT")
                        .foregroundColor(.gray600)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.top, 20)
                    
                    Text("ver 1.0.0")
                        .foregroundColor(.gray400)
                        .font(.system(size: 11, weight: .semibold))
                }
                
                Spacer()
            }
            .padding(.vertical, 60)
            
            ForEach(
                AppInfoType.allCases,
                id: \.self
            ) { info in
                NavigationLink {
                    // TODO: - .copyrightInfo 추가
                    switch info {
                        
                    case .versionInfo, .dataPolicyInfo:
                        AppInfoWebView(
                            isLoading: $isLoading,
                            webURL: info.infoURL
                        )
                        .ignoresSafeArea(edges: .bottom)
                    }
                } label: {
                    TKListCell(label: info.rawValue) {
                    } trailingUI: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
    }
}

struct AppInfoWebView: UIViewRepresentable {
    #warning("LOADING PROGRESSVIEW NEEDED")
    @Binding var isLoading: Bool
    var webURL: URL?
    let webView: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = webURL else {
            webView.load(
                URLRequest(
                    url: URL(
                        string: "https://google.com"
                    )!
                )
            )
            return webView
        }
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = webURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
}

#Preview {
    NavigationStack {
        SettingsAppInfoView()
    }
}
