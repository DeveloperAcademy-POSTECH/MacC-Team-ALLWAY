//
//  AuthorizationRequestView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/07.
//

import SwiftUI

struct AuthorizationRequestView: View {
    var currentAuthStatus: AuthStatus
    
    var body: some View {
        VStack(spacing: 30) {
            /// 권한 사용 안내 문구
            Text("현재 **\(currentAuthStatus.rawValue)** 권한이 꺼져있어요.")
            Text("마이크와 음성 인식 기능은\n인식된 음성을 텍스트로 변환하기 위해 쓰이고 있어요.\n앱 사용을 희망하신다면 권한 허용 부탁드릴게요!🙏")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            
            Button("불쌍하니까 권한 주러 가기") {
                /// 권한 허용을 위한 앱 시스템설정으로 이동
                if let url = URL(
                    string: UIApplication.openSettingsURLString
                ) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}


struct AuthorizationSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationRequestView(currentAuthStatus: .authIncompleted)
    }
}
