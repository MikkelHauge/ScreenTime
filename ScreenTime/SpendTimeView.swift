//
//  SpendTimeView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//


import SwiftUI

struct Bouncy3DButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .rotation3DEffect(
                .degrees(configuration.isPressed ? 5 : 0),
                axis: (x: 5, y: -3, z: 3)
            )
            .shadow(color: .black.opacity(configuration.isPressed ? 0.1 : 0.3),
                    radius: configuration.isPressed ? 2 : 15,
                    x: 0, y: configuration.isPressed ? 1 : 12)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct SpendTimeView: View {
    @State private var screenTimeToSpend = 60
    @EnvironmentObject var ScreenTimeModel: ScreenTimeModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Screen Time:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)  // Fixed padding to top
            Text("\(ScreenTimeModel.timeBank) min")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 1)  // Fixed padding to top
            
            Picker("Spend Time", selection: $screenTimeToSpend) {
                ForEach(Array(stride(from: 5, through: 120, by: 5)), id: \.self) { number in
                    Text("\(number) minutes").tag(number)
                }
            }
            .pickerStyle(.wheel)
            .padding(.top, 100)
            
            .padding()
            
            HStack(spacing: 20) {
                PressableButton(title: "Spend Screen Time", color: .red) {
                    ScreenTimeModel.spendTime(minutes: screenTimeToSpend, category: .spent)
                    screenTimeToSpend = 5
                }
                .sensoryFeedback(.increase, trigger: screenTimeToSpend)

                PressableButton(title: "Log Free Time", color: .orange) {
                    ScreenTimeModel.logTime(minutes: screenTimeToSpend, category: .free)
                    screenTimeToSpend = 5
                }
                .sensoryFeedback(.increase, trigger: screenTimeToSpend)
            }
            .padding(.horizontal)
            
        }
        .navigationTitle("Spend Screen Time")
    }
}

#Preview {
    SpendTimeView()
        .environmentObject(ScreenTimeModel())
}
