//
//  ContentView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var model = ScreenTimeModel()

    var body: some View {
        ZStack {
            TabView {
                NavigationStack {
                    AddTimeView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
                NavigationStack {
                    SpendTimeView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Spend", systemImage: "minus")
                }
                NavigationStack{
                    TimerView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

                NavigationStack {
                    LogView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Log", systemImage: "terminal")
                }
            } 
            
            

        }
        
        
    }
}
struct BackgroundModifier: ViewModifier {
    var imageName: String

    func body(content: Content) -> some View {
        content
            .background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(
                        .all
                    )  // To make the background cover the entire screen
            )
    }
}

extension View {
    func backgroundImage(_ imageName: String) -> some View {
        self.modifier(BackgroundModifier(imageName: imageName))
    }
}


#Preview {
    ContentView()
}
