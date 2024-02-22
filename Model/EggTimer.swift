//
//  EggTimer.swift
//  isItCooked
//
//  Created by Tamanna on 03/10/23.
//

import Foundation
protocol EggTimerProtocol
{
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: EggTimer) }
                      
class EggTimer
{
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 360 // default = 6 minutes
    var elapsedTime: TimeInterval = 0
    var isStopped: Bool {return timer == nil && elapsedTime == 0}
    var isPaused: Bool {return timer == nil && elapsedTime>0}
    var delegate: EggTimerProtocol?
    
    @objc dynamic func timerAction() {
        guard let startTime = startTime else { return }
        elapsedTime = -startTime.timeIntervalSinceNow
        let secondsRemaining = (duration - elapsedTime).rounded()
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        }
        else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction),
                                     userInfo: nil, repeats: true); timerAction() }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true); timerAction() }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerAction() }
    
    func resetTimer() {
        timer = nil
        startTime = nil
        duration = 360
        elapsedTime = 0
        timerAction() }
    
}



