//
//  TimerAttributes.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 22/07/2025.
//

import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: Int
    }

    var totalTime: Int
}
