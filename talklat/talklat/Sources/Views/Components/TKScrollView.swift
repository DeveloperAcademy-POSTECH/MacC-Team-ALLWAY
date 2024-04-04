//
//  TKScrollView.swift
//  talklat
//
//  Created by Celan on 11/12/23.
//

import SwiftUI

struct TKScrollView: View {
    enum TKScrollContents {
        case question(question: String, answer: String, curtainAlignment: Alignment)
        case answer(answer: String, curtainAlignment: Alignment)
        case answerCard(text: String, curtainAlignment: Alignment)
    }

    let style: TKScrollContents
    let curtain: () -> LinearGradient
    
    init(
        style: TKScrollContents,
        curtain: @escaping () -> LinearGradient
    ) {
        self.style = style
        self.curtain = curtain
    }
    // MARK: - BODY
    var body: some View {
        switch style {
        case let .question(question, answer, align):
            VStack {
                if question.isEmpty && answer.isEmpty {
                    BDText(text: Constants.SHOWINGVIEW_GUIDINGMESSAGE, style: .T1_B_170)
                        .foregroundColor(Color.GR4) // GR4 색상
                        .multilineTextAlignment(.leading)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                        .padding(.horizontal, 24)
                } else {
                    BDText(text: question, style: answer.isEmpty ? .T1_B_170 : .T3_B_160)
                        .multilineTextAlignment(.leading)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                        .padding(.horizontal, 24)
                        .animation(
                            .easeInOut,
                            value: answer.isEmpty
                        )
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
        case let .answer(answer, align):
            ScrollViewReader { proxy in
                ScrollView {
                    BDText(text: answer, style: .T1_B_170)
                        .foregroundStyle(Color.white)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                        .animation(
                            .easeInOut,
                            value: answer
                        )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 0)
                        .id("SCROLL_BOTTOM")
                }
                // MARK: Scroll Position Here
                .onChange(of: answer) { _, newValue in
                    if newValue.count > 50 {
                        withAnimation {
                            proxy.scrollTo(
                                "SCROLL_BOTTOM",
                                anchor: .top
                            )
                        }
                    }
                }
                .padding(.top, 14)
                .overlay(alignment: align) {
                    curtain()
                        .frame(height: 50)
                }
            }
            .scrollIndicators(.hidden)
            
        case let .answerCard(answer, align):
            ScrollView {
                BDText(text: answer, style: .T3_B_160)
                    .foregroundStyle(Color.white)
                    .lineSpacing(8)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
            }
            .overlay(alignment: align) {
                curtain()
                    .frame(height: 50)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private func scrollViewCurtainBuilder(
        colors: [Color],
        _ startPoint: UnitPoint,
        _ endPoint: UnitPoint
    ) -> LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

#Preview {
    @State var answer = "Answer"
    @State var question = "Question"
    
    return TKScrollView(
        style: .answer(answer: answer, curtainAlignment: .top), curtain: {
            LinearGradient(
                colors: [
                    .BaseBGWhite
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    )
}
