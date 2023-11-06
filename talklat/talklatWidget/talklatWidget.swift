//
//  talklatWidget.swift
//  talklatWidget
//
//  Created by Celan on 11/6/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    struct SimpleEntry: TimelineEntry {
        let date: Date
        let configuration: ConfigurationAppIntent
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entries: [SimpleEntry] = []
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct talklatWidgetSystemSmallView: View {
    var body: some View {
        VStack {
            Text("TALKLAT")
                .bold()
            
            Text("새 대화 시작")
                .font(.caption)
                .bold()
        }
        .unredacted()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background {
            Circle()
                .foregroundStyle(.accent)
                .padding()
                .shadow(radius: 10)
        }
        .background {
            Circle()
                .foregroundStyle(.accent.opacity(0.7))
                .offset(x: 30, y: 30)
        }
        .background {
            Circle()
                .foregroundStyle(Color.red)
                .offset(x: 30, y: 30)
        }
        .background {
            Circle()
                .foregroundStyle(.accent.opacity(0.5))
                .offset(x: -24, y: -24)
        }
        .background {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.accent.opacity(0.5))
                .offset(x: 40, y: -48)
        }
        .background {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.accent.opacity(0.9))
                .offset(x: -40, y: 48)
        }
    }
}

#Preview(as: .systemSmall) {
    TalklatWidgetSystemSmall()
} timeline: {
    Provider.SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
}
