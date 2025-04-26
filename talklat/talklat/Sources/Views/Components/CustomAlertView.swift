//
//  CustomAlertView.swift
//  talklat
//
//  Created by user on 11/14/23.
//

import SwiftUI

struct CustomAlertView<Button: View>: View {
    let title: String
    let message: String
    let defaultButton: Button
    let cancelButton: Button
    
    init(
        title: String,
        message: String,
        @ViewBuilder defaultButton: () -> Button,
        @ViewBuilder cancelButton: () -> Button
    ) {
        self.title = title
        self.message = message
        self.defaultButton = defaultButton()
        self.cancelButton = cancelButton()
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.5)
            
            VStack(spacing: 0) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color.OR5)
                    .padding()
                
                BDText(text: title, style: ._17H_B)
                    .padding(.bottom)
                
                BDText(text: message, style: ._15H2_SMB)
                    .foregroundStyle(Color.GR6)
                    .padding([.bottom, .horizontal])
                
                HStack {
                    defaultButton
                        .foregroundStyle(Color.GR5)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.GR2)
                        }
                        .padding([.bottom, .leading])
                    
                    cancelButton
                        .foregroundStyle(Color.BaseBGWhite)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.OR5)
                            
                        }
                        .padding([.bottom, .trailing])
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.BaseBGWhite)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CustomAlertView(title: "변경 사항 취소", message: "현재 변경한 내용이 저장되지 않아요", defaultButton: {
        Button("아니오, 저장할래요") {
            
        }
    }, cancelButton:  {Button("네, 취소할래요") {
        
    }}
    )
}
