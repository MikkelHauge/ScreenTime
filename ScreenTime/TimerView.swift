//
//  TimerView.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 22/07/2025.
//
import SwiftUI
import Combine
import AVFoundation
import ActivityKit

struct TimerView: View {
    @State private var selectedMinutes = 0
    @State private var remainingSeconds = 0
    @State private var isRunning = false
    @State private var showPicker = true
    @State private var timerSubscription: Cancellable? = nil
    @State private var audioPlayer: AVPlayer?
    @State private var isAlarmPlaying = false
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("endTime") var savedEndTime: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 30) {
                if showPicker {
                    timePicker
                } else {
                    countdownText
                }

                if isAlarmPlaying {
                    stopAlarmButton
                }

                if isRunning && !isAlarmPlaying {
                    cancelButton
                }

                startButton
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    resumeTimerIfNeeded()
                }
            }
        }
        .onAppear {
            setupAudioSession()
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    private var timePicker: some View {
        Picker("Set Timer", selection: $selectedMinutes) {
            ForEach(Array(stride(from: 2, through: 120, by: 2)), id: \.self) { min in
                Text("\(min) minutes").tag(min)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 150)
    }

    private var countdownText: some View {
        Text(formatTime(remainingSeconds))
            .font(.system(size: 60, design: .monospaced))
            .bold()
            .foregroundColor(.white)
    }

    private var stopAlarmButton: some View {
        Button("Stop Alarm") {
            stopAlarm()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var cancelButton: some View {
        Button("Cancel Timer") {
            cancelTimer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var startButton: some View {
        Button(action: {
            if !isRunning && selectedMinutes > 0 {
                startTimer()
            }
        }) {
            Text("Start Timer")
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedMinutes > 0 ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(selectedMinutes == 0)
        .padding(.horizontal)
    }

    private func startTimer() {
        savedEndTime = Date().timeIntervalSince1970 + Double(selectedMinutes * 60)
        remainingSeconds = selectedMinutes * 60
        showPicker = false
        isRunning = true
        startCountdown()
    }

    private func startCountdown() {
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let secondsLeft = Int(savedEndTime - Date().timeIntervalSince1970)
                if secondsLeft > 0 {
                    remainingSeconds = secondsLeft
                } else {
                    remainingSeconds = 0
                    timerSubscription?.cancel()
                    isRunning = false
                    playAlarm()
                }
            }
    }

    private func resumeTimerIfNeeded() {
        let now = Date().timeIntervalSince1970
        let timeLeft = Int(savedEndTime - now)

        if timeLeft > 0 && isRunning {
            remainingSeconds = timeLeft
            startCountdown()
        }
    }

    private func cancelTimer() {
        timerSubscription?.cancel()
        isRunning = false
        remainingSeconds = 0
        selectedMinutes = 0
        showPicker = true
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    private func playAlarm() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
            return
        }

        guard let sound = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        audioPlayer = AVPlayer(url: sound)
        audioPlayer?.play()
        isAlarmPlaying = true
    }

    private func stopAlarm() {
        audioPlayer?.pause()
        audioPlayer = nil
        isAlarmPlaying = false
        showPicker = true
        selectedMinutes = 0
    }
}

#Preview {
    TimerView()
}
