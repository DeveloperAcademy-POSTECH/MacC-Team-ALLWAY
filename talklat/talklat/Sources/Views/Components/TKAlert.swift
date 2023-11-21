//
//  TKFloatingView.swift
//  talklat
//
//  Created by Celan on 11/14/23.
//

import SwiftUI

struct TKAlert<ActionButtonLabel: View>: View {
    @Binding var bindingPresentedFlag: Bool

    let alertStyle: AlertStyle
    let confirmButtonAction: () -> Void
    let actionButtonLabel: () -> ActionButtonLabel    
    
    // MARK: init
    init(
        style alertStyle: AlertStyle,
        isPresented: Binding<Bool>,
        confirmButtonAction: @escaping () -> Void,
        @ViewBuilder actionButtonLabel: @escaping () -> ActionButtonLabel
    ) {
        self.alertStyle = alertStyle
        self._bindingPresentedFlag = isPresented
        self.confirmButtonAction = confirmButtonAction
        self.actionButtonLabel = actionButtonLabel
    }
    
    // MARK: BODY
    var body: some View {
        if bindingPresentedFlag {
            ZStack {
                VStack(
                    alignment: .center,
                    spacing: 16
                ) {
                    image
                        .scaleEffect(1.3)
                        .foregroundStyle(tintColor)
                        .padding(.top, 24)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color.GR9)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(Color.GR6)
                        .multilineTextAlignment(.center)
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                    HStack(spacing: 9) {
                        Button {
                            withAnimation {
                                bindingPresentedFlag = false
                            }
                        } label: {
                            Text(dismissText)
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(Color.GR6)
                                .frame(width: 140, height: 56)
                                .background {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color.GR2)
                                }
                        }
                        
                        Button {
                            confirmButtonAction()
                        } label: {
                            actionButtonLabel()
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(Color.white)
                                .frame(width: 140, height: 56)
                                .background {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(tintColor)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    
                }
                .frame(width: 330, height: frameHeight)
                .background { Color.AlertBGWhite }
                .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            bindingPresentedFlag = false
                        }
                    }
            }
        }
    }
}

extension TKAlert {
    enum AlertStyle {
        case mic, cancellation, removeTextReplacement
        case removeConversation(conversationTitle: String)
    }
    
    var frameHeight: CGFloat {
        switch alertStyle {
        case .mic, .removeConversation(_): 240
        case .cancellation, .removeTextReplacement: 220
        }
    }
    
    var tintColor: Color {
        switch alertStyle {
        case .mic, .cancellation: Color.OR6
        case .removeTextReplacement, .removeConversation(_): Color.red
        }
    }
    
    var image: Image {
        switch alertStyle {
        case .mic, .cancellation: Image(systemName: "exclamationmark.triangle.fill")
        case .removeTextReplacement, .removeConversation(_): Image(systemName: "trash.fill")
        }
    }
    
    var title: String {
        switch alertStyle {
        case .mic: "마이크 권한 없음"
        case .cancellation: "변경 사항 취소"
        case .removeTextReplacement: "텍스트 대치 삭제"
        case .removeConversation: "대화 삭제"
        }
    }
    
    var description: String {
        switch alertStyle {
        case .mic:
            """
            비스담을 이용하기 위해
            마이크 접근 권한을 허용해 주세요.
            """
        case .cancellation:
            """
            현재 변경한 내용이 저장되지 않아요.
            """
        case .removeTextReplacement:
            """
            현재 텍스트 대치가 삭제됩니다.
            """
        case let .removeConversation(conversationTitle):
            """
            '\(conversationTitle)'에 저장된
            모든 데이터가 삭제됩니다.
            """
        }
    }
    
    var dismissText: String {
        switch alertStyle {
        case .mic: "돌아가기"
        case .cancellation: "아니요, 저장할래요"
        case .removeTextReplacement: "아니요, 취소할래요"
        case .removeConversation(_): "아니요, 취소할래요"
        }
    }
}

struct PreviewPro: PreviewProvider {
    @State static var flag = true
    
    static var previews: some View {
        NavigationStack {
            Button {
                flag.toggle()
                print(flag)
            } label: {
                Text("???")
            }
        }
        .overlay {
            TKAlert(style: .mic, isPresented: $flag) {
                print("conf")
            } actionButtonLabel: {
                HStack {
                    Text("설정으로 이동")
                    
                    Image(systemName: "arrow.up.right.square.fill")
                }
            }
        }
    }
}
