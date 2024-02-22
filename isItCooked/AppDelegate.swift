//
//  AppDelegate.swift
//  isItCooked
//
//  Created by Tamanna on 28/09/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func enableMenus(start: Bool, stop: Bool, reset: Bool)
    { startTimerMenuItem.isEnabled = start
        stopTimerMenuItem.isEnabled = stop
        resetTimerMenuItem.isEnabled = reset
        
    }
                            
    @IBOutlet weak var startTimerMenuItem: NSMenuItem!
    
    @IBOutlet weak var stopTimerMenuItem: NSMenuItem!
    
    @IBOutlet weak var resetTimerMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        enableMenus(start: true, stop: false, reset: false)
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

