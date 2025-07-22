//
//  AddRemoveTimeView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//

import SwiftUI




struct AddTimeView: View {
    @State private var screenTimeToAdd = 5
    @EnvironmentObject var ScreenTimeModel: ScreenTimeModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Add Screen Time")
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Add Time", selection: $screenTimeToAdd) {
                ForEach(Array(stride(from: 60, through: 120, by: 5)), id: \.self) { number in
                    Text("\(number) minutes").tag(number)
                }
            }
            .pickerStyle(.wheel)
            
            Button("Spend Screen Time") {
                ScreenTimeModel.addTime(minutes: screenTimeToAdd, category: "Reading")
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
    AddTimeView()
        .environmentObject(ScreenTimeModel()) 
}
