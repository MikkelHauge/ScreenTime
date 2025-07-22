//
//  SpendTimeView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//


import SwiftUI

struct SpendTimeView: View {
    @State private var screenTimeToAdd = 60
    @EnvironmentObject var ScreenTimeModel: ScreenTimeModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Spend Screen Time")
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Spend Time", selection: $screenTimeToAdd) {
                ForEach(Array(stride(from: 60, through: 120, by: 5)), id: \.self) { number in
                    Text("\(number) minutes").tag(number)
                }
            }
            .pickerStyle(.wheel)
            
            Button("Spend Screen Time") {
                ScreenTimeModel.spendTime(minutes: screenTimeToAdd, category: "Reading")
                screenTimeToAdd = 0
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text("Banked Time: \(ScreenTimeModel.timeBank) min")
                .bold()
        }
        .padding()
    }
}

#Preview {
    SpendTimeView()
        .environmentObject(ScreenTimeModel()) // ✅ Needed for preview to work
}
