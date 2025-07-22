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
    
    struct LogEntry: Identifiable, Codable {
        var id = UUID()
        let category: String
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
    
    func addTime(minutes: Int, category: String) {
        let actualMinutes: Int

        if category == "Drawing" || category == "Writing" {
            actualMinutes = Int(ceil(Double(minutes) / 2.0))
        } else {
            actualMinutes = minutes
        }

        timeBank += actualMinutes
        let entry = LogEntry(category: category, minutes: actualMinutes, timeStamp: Date())
        log.append(entry)
        print("Banked time: \(timeBank)")
    }
    
    func spendTime(minutes: Int, category: String) {
        // Calculate actual minutes to spend (can't spend more than timeBank)
        let minutesToSpend = min(minutes, timeBank)
        timeBank -= minutesToSpend
        
        let entry = LogEntry(category: "-\(category)", minutes: minutes, timeStamp: Date())
        log.append(entry)
        
        print(timeBank)
    }
    
    func clearOldEntries() -> Int { // clear up old data.
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let originalCount = log.count
        log.removeAll { $0.timeStamp < cutoffDate }
        saveLog()
        return originalCount - log.count
    }


}
