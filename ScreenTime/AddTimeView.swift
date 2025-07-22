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
    let addTimeBtn: LocalizedStringKey = "Add Screen Time"
    let addBonusBtn: LocalizedStringKey = "Add Bonus Time"
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Screen Time:")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("\(ScreenTimeModel.timeBank) min")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 1)
            
            Picker("Add Time", selection: $screenTimeToAdd) {
                ForEach(Array(stride(from: 5, through: 120, by: 5)), id: \.self) { number in
                    Text("\(number) minutes").tag(number)
                }
            }
            .pickerStyle(.wheel)
            .padding(.top, 100)
            
            .padding()
            VStack {
                HStack(spacing: 20) {

                    
                    PressableButton(title: addTimeBtn, color: .blue) {
                        ScreenTimeModel.addTime(minutes: screenTimeToAdd, category: .earned)
                        screenTimeToAdd = 5
                    }
                    .sensoryFeedback(.increase, trigger: screenTimeToAdd)

                    PressableButton(title: addBonusBtn, color: .green) {
                        ScreenTimeModel.addTime(minutes: screenTimeToAdd, category: .bonus)
                        screenTimeToAdd = 5
                    }
                    .sensoryFeedback(.increase, trigger: screenTimeToAdd)
                    
                }
                .padding(.horizontal)
                
            }
        }
        .navigationTitle("Add Screen Time")
    }
}

#Preview {
    AddTimeView()
        .environmentObject(ScreenTimeModel()) 
}
