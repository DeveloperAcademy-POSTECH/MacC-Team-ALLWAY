//
//  talklatWidgetBundle.swift
//  talklatWidget
//
//  Created by Celan on 11/6/23.
//

import WidgetKit
import SwiftUI

@main
struct talklatWidgetBundle: WidgetBundle {
    var body: some Widget {
        TalklatWidgetSystemSmall()
    }
}

struct TalklatWidgetSystemSmall: Widget {
    let kind: String = "Talklat: Easy Start!"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
//            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { _ in
            talklatWidgetSystemSmallView()
                .containerBackground(
                    .fill.tertiary,
                    for: .widget
                )
        }
        .contentMarginsDisabled()
        .configurationDisplayName("TALKLAT: 새 대화 시작하기")
        .description("위젯을 배치해서 다른 사람과 바로 대화를 시작해 볼까요?")
    }
}
