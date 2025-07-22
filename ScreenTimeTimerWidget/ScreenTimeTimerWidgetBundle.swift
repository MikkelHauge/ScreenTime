//
//  ScreenTimeTimerWidgetBundle.swift
//  ScreenTimeTimerWidget
//
//  Created by Mikkel Hauge on 22/07/2025.
//

import WidgetKit
import SwiftUI

@main
struct ScreenTimeTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ScreenTimeTimerWidget()
        ScreenTimeTimerWidgetControl()
        ScreenTimeTimerWidgetLiveActivity()
    }
}
