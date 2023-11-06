//
//  talklatWidgetLiveActivity.swift
//  talklatWidget
//
//  Created by Celan on 11/6/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct talklatWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct talklatWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: talklatWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension talklatWidgetAttributes {
    fileprivate static var preview: talklatWidgetAttributes {
        talklatWidgetAttributes(name: "World")
    }
}

extension talklatWidgetAttributes.ContentState {
    fileprivate static var smiley: talklatWidgetAttributes.ContentState {
        talklatWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: talklatWidgetAttributes.ContentState {
         talklatWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: talklatWidgetAttributes.preview) {
   talklatWidgetLiveActivity()
} contentStates: {
    talklatWidgetAttributes.ContentState.smiley
    talklatWidgetAttributes.ContentState.starEyes
}
