//
//  LogView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//

import SwiftUI

enum LogFilter: String, CaseIterable {
    case recent = "Recent"
    case last7Days = "Last 7 Days"
    case all = "All"
}

struct LogView: View {
    @EnvironmentObject var model: ScreenTimeModel
    @State private var selectedFilter: LogFilter = .recent
    
    @State private var showAlert = false // for deleting
    @State private var deletedCount = 0

    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(LogFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            List(filteredLog()) { entry in
                VStack(alignment: .leading) {
                    Text("\(entry.category): \(entry.minutes) min")
                    Text(entry.timeStamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Log")
        .toolbar {
            Menu {
                Button("Clear entries older than 30 days", role: .destructive) {
                    deletedCount = model.clearOldEntries()
                    if deletedCount > 0 {
                        showAlert = true
                    }
                }
                .alert("Old logs deleted", isPresented: $showAlert, actions: {
                    Button("OK", role: .cancel) {}
                }, message: {
                    Text("\(deletedCount) old logs deleted.")
                })
            } label: {
                Label("Options", systemImage: "ellipsis.circle")
            }
        }
    }

    func filteredLog() -> [ScreenTimeModel.LogEntry] {
        let now = Date()
        let sortedLog = model.log.sorted { $0.timeStamp > $1.timeStamp }
        
        switch selectedFilter {
        case .recent:
            return Array(sortedLog.prefix(20))

        case .last7Days:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            let filtered = model.log.filter { $0.timeStamp >= oneWeekAgo }
            let sortedFiltered = filtered.sorted { $0.timeStamp > $1.timeStamp }
            return Array(sortedFiltered.prefix(1000))  // limit to 1000 most recent in last 7 days

        case .all:
            return sortedLog
        }
    }
}


#Preview {
    LogView().environmentObject(ScreenTimeModel())
}
