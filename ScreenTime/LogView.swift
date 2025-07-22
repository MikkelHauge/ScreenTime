import SwiftUI

enum LogFilter: String, CaseIterable {
    case all = "all"
    case added = "added"
    case used = "used"
    case free = "free"

    var localizedName: LocalizedStringKey {
        switch self {
        case .all:
            return "All"
        case .added:
            return "Added"
        case .used:
            return "Used"
        case .free:
            return "Free"
        }
    }
}



struct LogView: View {
    @EnvironmentObject var model: ScreenTimeModel
    @State private var selectedFilter: LogFilter = .all
    
    @State private var showDeleteAlert = false  // For clearing log entries
    @State private var showResetAlert = false   // For resetting the time bank
    @State private var showClearOldAlert = false // For deleting old log entries
    
    @State private var deletedCount = 0

    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(LogFilter.allCases, id: \.self) { filter in
                    Text(filter.localizedName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .glassEffect()

            List(filteredLog()) { entry in
                VStack(alignment: .leading) {
                    let changeDescription = "\(entry.minutes) min (\(entry.previousTime) → \(entry.currentTime))"
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text(entry.category.localized)
                                .foregroundColor(entry.category.color)
                                .bold()
                            Text(": \(changeDescription)")
                                .fontDesign(.monospaced)
                                .font(.caption)
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(entry.timeStamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(entry.category.color.opacity(0.7))
                }
            }
        }
        .navigationTitle("Log")
        .toolbar {
            Menu {
                // Button for clearing all log entries
                Button("Clear Log", role: .destructive) {
                    showDeleteAlert = true
                }

                // Button for resetting the time bank
                Button("Reset Banked Time", role: .destructive) {
                    showResetAlert = true
                }

                // Button for clearing log entries older than 30 days
                Button("Clear entries older than 30 days", role: .destructive) {
                    showClearOldAlert = true
                }
            } label: {
                Label("Options", systemImage: "ellipsis.circle")
            }
        }
        // Confirmation alert for clearing all logs
        .alert("Are you sure?", isPresented: $showDeleteAlert, actions: {
            Button("Cancel", role: .cancel) {
                showDeleteAlert = false
            }
            Button("Delete All Logs", role: .destructive) {
                clearLog()  // Perform the clear log action
            }
        }, message: {
            Text("This will delete all log entries. Are you sure?")
        })
        // Confirmation alert for resetting the time bank
        .alert("Are you sure?", isPresented: $showResetAlert, actions: {
            Button("Cancel", role: .cancel) {
                showResetAlert = false
            }
            Button("Reset Bank", role: .destructive) {
                resetTimeBank()  // Perform the reset bank action
            }
        }, message: {
            Text("This will reset your banked screen time. Are you sure?")
        })
        // Confirmation alert for deleting old log entries
        .alert("Are you sure?", isPresented: $showClearOldAlert, actions: {
            Button("Cancel", role: .cancel) {
                showClearOldAlert = false
            }
            Button("Delete Old Logs", role: .destructive) {
                deleteOldLogs()  // Perform the delete old logs action
            }
        }, message: {
            Text("This will delete all log entries older than 30 days. Are you sure?")
        })
    }

    // Function to clear all logs
    private func clearLog() {
        model.clearLog()
    }

    // Function to reset the time bank
    private func resetTimeBank() {
        model.timeBank = 0
    }

    // Function to delete log entries older than 30 days
    private func deleteOldLogs() {
        deletedCount = model.clearOldEntries()  // Call the function to delete old entries
        if deletedCount > 0 {
            showDeleteAlert = true  // Show a confirmation if logs were deleted
        }
    }

    private func filteredLog() -> [ScreenTimeModel.LogEntry] {
        let sortedLog = model.log.sorted { $0.timeStamp > $1.timeStamp }
        
        switch selectedFilter {
        case .all:
            return sortedLog
            
        case .added:
            // Includes earned + bonus + added categories you want to show as "added"
            return sortedLog.filter {
                $0.category == .earned || $0.category == .bonus
            }
            
            
        case .free:
            return sortedLog.filter { $0.category == .free }
            
        case .used:
            return sortedLog.filter { $0.category == .spent }
        }
        
        
        func colorForCategory(_ category: String) -> Color {
            switch category {
            case "Earned Screen Time":
                return .blue
            case "Bonus Screen Time":
                return .green
            case "Spent Screen Time":
                return .red
            case "Free Screen Time":
                return .orange
            default:
                return .primary
            }
        }
        
    }
}

#Preview {
    LogView().environmentObject(ScreenTimeModel())
}
