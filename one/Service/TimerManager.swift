//
//  TimerManager.swift
//  one
//
//  Created by sidney on 6/1/21.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    
    private var timerDict: [TimerName: Timer?] = [:]
    
    private init() {
        
    }
    
    enum TimerName: String {
        case musicPosterLoop = "musicPosterLoop"
        case musicCarouselLoop = "musicCarouselLoop"
    }
    
    func setTimer(timerName: TimerName, timer: Timer) {
        self.timerDict[timerName] = timer
    }
    
    func getTimer(timerName: TimerName) -> Timer? {
        return self.timerDict[timerName] ?? nil
    }
    
    func deleteTimer(timerName: TimerName) {
        self.timerDict.removeValue(forKey: timerName)
    }
    
    func invalidateTimer(timerName: TimerName) {
        guard let timer = self.getTimer(timerName: timerName) else { return }
        timer.invalidate()
//        self.deleteTimer(timerName: timerName)
    }
    
    func validateTimer(timerName: TimerName) {
        guard let timer = self.getTimer(timerName: timerName) else { return }
        timer.fire()
    }
}
