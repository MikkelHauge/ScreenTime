//
//  ScreenTimeModel.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 20/07/2025.
//

import Foundation
import SwiftUI

class ScreenTimeModel: ObservableObject {

    
    @Published var timeBank = 0 {
        didSet {
            if timeBank < 0 {
                timeBank = 0
            }
            UserDefaults.standard.set(timeBank, forKey: "timeBank")
            print("saved time bank: " + String(timeBank))
        }
        
    }
    
    enum LogCategory: String, Codable {
        case earned = "Earned Screen Time"
        case bonus = "Bonus Screen Time"
        case spent = "Spent Screen Time"
        case free = "Free Screen Time"
        
        var localized: LocalizedStringKey {
            switch self {
            case .earned:
                return "Earned Screen Time" // earned regularly
            case .bonus:
                return "Bonus Screen Time" // for bonus time given under certain special situations
            case .spent:
                return "Spent Screen Time"  // normal usage
            case .free:
                return "Free Screen Time" // use now, not added to time bank
            }
        }

        var color: Color {
            switch self {
            case .earned: return .blue
            case .bonus: return .green
            case .spent: return .red
            case .free: return .orange
            }
        }
    }


    
    struct LogEntry: Identifiable, Codable {
        var id = UUID()
        let category: LogCategory
        let previousTime: Int
        let currentTime: Int
        let minutes: Int
        let timeStamp: Date
    }
    
    @Published var log: [LogEntry] = [] {
        didSet {
            saveLog()
        }
    }
    
    init() {
        loadTimeBank()
        loadLog()
    }
    
    
       private func saveLog() {
           if let encoded = try? JSONEncoder().encode(log) {
               UserDefaults.standard.set(encoded, forKey: "log")
               print("saved log")
           }
       }
       
       private func loadLog() {
           if let savedData = UserDefaults.standard.data(forKey: "log") {
               if let decoded = try? JSONDecoder().decode([LogEntry].self, from: savedData) {
                   log = decoded
                   print("loaded log")
               }
           }
       }
       
       private func loadTimeBank() {
           timeBank = UserDefaults.standard.integer(forKey: "timeBank")
           print("loaded time bank: " + String(timeBank))
       }
    
    func addTime(minutes: Int, category: LogCategory) {
        let actualMinutes: Int
        let prevBankedMinutes: Int
        prevBankedMinutes = timeBank
        actualMinutes = minutes
        timeBank += actualMinutes
        let entry = LogEntry(
            category: category,
            previousTime: prevBankedMinutes,
            currentTime: timeBank,
            minutes: minutes,
            timeStamp: Date()
        )
        log.append(entry)
        print("Banked time: \(timeBank)")
    }

    
    func spendTime(minutes: Int, category: LogCategory) {
        let prevBankedMinutes = timeBank
        let minutesToSpend = min(minutes, timeBank)
        timeBank -= minutesToSpend
        
        let entry = LogEntry(
            category: category,
            previousTime: prevBankedMinutes,
            currentTime: timeBank,
            minutes: minutesToSpend,
            timeStamp: Date()
        )
        
        log.append(entry)
        print("Time spent: \(minutesToSpend), new balance: \(timeBank)")
    }
    
    func logTime(minutes: Int, category: LogCategory) {
        let entry = LogEntry(
            category: category,
            previousTime: timeBank,
            currentTime: timeBank,
            minutes: minutes,
            timeStamp: Date()
        )
        
        log.append(entry)
        print("Logged free time: \(minutes) min, bank unchanged: \(timeBank)")
    }

    
    func clearOldEntries() -> Int { // clear up old data.
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let originalCount = log.count
        log.removeAll { $0.timeStamp < cutoffDate }
        saveLog()
        return originalCount - log.count
    }
    // Clear the entire log
    func clearLog() {
        log.removeAll()
    }
    
    // Reset time bank to 0
    func resetBank() {
        timeBank = 0
    }

}
