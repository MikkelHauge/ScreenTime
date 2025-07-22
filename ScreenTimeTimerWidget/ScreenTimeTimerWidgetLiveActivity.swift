//
//  ScreenTimeTimerWidgetLiveActivity.swift
//  ScreenTimeTimerWidget
//
//  Created by Mikkel Hauge on 22/07/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ScreenTimeTimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var timeRemaining: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ScreenTimeTimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScreenTimeTimerWidgetAttributes.self) { context in
            VStack {
                Text("Time left: \(context.state.timeRemaining) seconds")
                    .font(.headline)
            }
            .activityBackgroundTint(Color.blue.opacity(0.3))
            .activitySystemActionForegroundColor(.blue)
        }
        dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Time: \(context.state.timeRemaining)")
                        .font(.headline)
                }
            } compactLeading: {
                Text("\(context.state.timeRemaining)")
            } compactTrailing: {
                Image(systemName: "timer")
            } minimal: {
                Image(systemName: "timer")
            }
        }
    }
}

extension ScreenTimeTimerWidgetAttributes {
    fileprivate static var preview: ScreenTimeTimerWidgetAttributes {
        ScreenTimeTimerWidgetAttributes(name: "World")
    }
}

extension ScreenTimeTimerWidgetAttributes.ContentState {
    static var preview1 = ScreenTimeTimerWidgetAttributes.ContentState(timeRemaining: 120)
    static var preview2 = ScreenTimeTimerWidgetAttributes.ContentState(timeRemaining: 60)
}


#Preview("Notification", as: .content, using: ScreenTimeTimerWidgetAttributes.preview) {
    ScreenTimeTimerWidgetLiveActivity()
} contentStates: {
    ScreenTimeTimerWidgetAttributes.ContentState.preview1
    ScreenTimeTimerWidgetAttributes.ContentState.preview2
}
