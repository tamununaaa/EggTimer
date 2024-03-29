//
//  ViewController.swift
//  isItCooked
//
//  Created by Tamanna on 28/09/23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var eggImageView: NSImageView!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var eggTimer = EggTimer()
    var prefs = Preferences()
    
    
    override func viewDidLoad() {
        eggTimer.delegate = self
        super.viewDidLoad()
        setupPrefs()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if eggTimer.isPaused { eggTimer.resumeTimer() }
        else {
            eggTimer.duration = prefs.selectedTime
            eggTimer.startTimer()
        }
        configureButtonsAndMenus()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        eggTimer.stopTimer()
        configureButtonsAndMenus()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        eggTimer.resetTimer()
        updateDisplay(for: prefs.selectedTime)
        configureButtonsAndMenus()
    }

    @IBAction func startTimerMenuItemSelected(sender: Any)
    {
        startButtonClicked(sender)
    }
    @IBAction func stopimerMenuItemSelected(sender: Any)
    {
        stopButtonClicked(sender)
    }
    @IBAction func resetTimerMenuItemSelected(sender: Any)
    {
        resetButtonClicked(sender)
    }
}

extension ViewController {
    func setupPrefs() {
        updateDisplay(for: prefs.selectedTime)
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in self.updateFromPrefs()}
    }
    func updateFromPrefs() {
        self.eggTimer.duration = self.prefs.selectedTime
        self.resetButtonClicked(self) }
}

extension ViewController {
    
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        if eggTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false }
        else if eggTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true }
        else {
            enableStart = false
            enableStop = true
            enableReset = false }
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset) } }
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timeRemaining)
        eggImageView.image = imageToDisplay(for: timeRemaining)
    }
    private func textToDisplay(for timeRemaining: TimeInterval)->String
    {
        if timeRemaining == 0 { return "Done!" }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining*60)
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        return timeRemainingDisplay
    }
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage?
    {
        let percentageComplete = 100 - (timeRemaining / prefs.selectedTime * 100)
        if eggTimer.isStopped { let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
        return NSImage(named: stoppedImageName)
    }
    let imageName: String
    switch percentageComplete
    {
        case 0..<25 : imageName = "0"
        case 25..<50: imageName = "25"
        case 50..<75 : imageName = "50"
        case 75..<100: imageName = "75"
        default: imageName = "100"
    }
    return NSImage(named: imageName) }   }


extension ViewController: EggTimerProtocol{
    func timeRemainingOnTimer(_ _timer: EggTimer, timeRemaining: TimeInterval)
    {
        updateDisplay(for: timeRemaining)
    }
    func timerHasFinished(_ timer: EggTimer)
    { updateDisplay(for:0) }
    
}

