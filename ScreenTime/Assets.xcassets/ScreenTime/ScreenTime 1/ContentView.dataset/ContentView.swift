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
                AddTimeView()
                    .tabItem {
                        Label("Add Time", systemImage: "plus")
                    }
                    .environmentObject(model)

                NavigationStack {
                    SpendTimeView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Spend", systemImage: "minus")
                }

                NavigationStack {
                    LogView()
                        .environmentObject(model)
                }
                .tabItem {
                    Label("Log", systemImage: "terminal")
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear() {
                UITabBar.appearance().backgroundColor = .clear
            }
            
            Image("background")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
                .border(Color.red)
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
