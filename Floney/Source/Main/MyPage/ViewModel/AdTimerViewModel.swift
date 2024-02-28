//
//  AdTimerViewModel.swift
//  Floney
//
//  Created by 남경민 on 2/21/24.
//
import Foundation

class AdTimerViewModel: ObservableObject {
    @Published var remainingTimeString: String = "6:00"
    var timer: Timer?

    init() {
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }

    func startTimer() {
        calculateRemainingTime() // 초기 남은 시간 계산
        
        timer?.invalidate() // 기존 타이머가 있으면 중지
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.calculateRemainingTime()
        }
    }

    func calculateRemainingTime() {
        guard let lastAdWatchTime = UserDefaults.standard.object(forKey: "lastAdWatchTime") as? Date else {
            return // 광고 시청 기록이 없으면 초기 값 유지
        }

        let sixHoursInSeconds: TimeInterval = 6 * 60 * 60
        let futureTime = lastAdWatchTime.addingTimeInterval(sixHoursInSeconds)
        let currentTime = Date()
        
        if futureTime > currentTime {
            let remainingTime = futureTime.timeIntervalSince(currentTime)
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) / 60 % 60
            remainingTimeString = String(format: "%02i:%02i", hours, minutes)
        } else {
            timer?.invalidate() // 남은 시간이 없으면 타이머 중지
            remainingTimeString = "6:00"
        }
    }
}
