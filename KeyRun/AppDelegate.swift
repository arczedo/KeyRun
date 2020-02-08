//
//  AppDelegate.swift
//  KeyRun
//
//  Created by user01 on 2019/06/05.
//  Copyright © 2019 user01. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


let ke = KeyEvent()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        ke.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

