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
            ScrollView {
                Text(question)
                    .font(
                        answer.isEmpty
                        ? .title
                        : .title3
                    )
                    .lineSpacing(
                        answer.isEmpty
                        ? 10
                        : 14
                    )
                    .bold()
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
            .scrollIndicators(.hidden)
            .frame(maxHeight: 250)
            .overlay(alignment: align) {
                curtain()
                    .frame(height: 50)
            }
            
        case let .answer(answer, align):
            ScrollViewReader { proxy in
                ScrollView {
                    Text(answer)
                        .font(.title)
                        .bold()
                        .lineSpacing(14)
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
                .padding(.top, 16)
                .overlay(alignment: align) {
                    curtain()
                        .frame(height: 50)
                }
            }
            .scrollIndicators(.hidden)
            
        case let .answerCard(answer, align):
            ScrollView {
                Text(answer)
                    .font(.title3)
                    .fontWeight(.heavy)
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
