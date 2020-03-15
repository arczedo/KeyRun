//
//  KeyPro.swift
//  KeyRun
//
//  Created by user01 on 2019/06/05.
//  Copyright © 2019 user01. All rights reserved.
//

import Cocoa
import Carbon

class KeyEvent: NSObject {
    var keyCode: CGKeyCode? = nil
    var isExclusionApp = false
//    let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    override init() {
        super.init()
    }
    func start() {

        let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let options: CFDictionary = [checkOptionPrompt: true] as NSDictionary
        if !AXIsProcessTrustedWithOptions(options) {
            // アクセシビリティに設定されていない場合、設定されるまでループで待つ
            Timer.scheduledTimer(timeInterval: 1.0,
                                 target: self,
                                 selector: #selector(KeyEvent.watchAXIsProcess(_:)),
                                 userInfo: nil,
                                 repeats: true)
        }
        else {
            self.watch()
        }
    }
    @objc func watchAXIsProcess(_ timer: Timer) {
        print("watchAXIsProcess.\(Date())")
        if AXIsProcessTrusted() {
            print("watchAXIsProcess trusted")

            timer.invalidate()
            self.watch()
        }
    }
    
    func watch() {
        // マウスのドラッグバグ回避のため、NSEventとCGEventを併用
        // CGEventのみでやる方法を捜索中
        let nsEventMaskList: NSEvent.EventTypeMask = [
            .leftMouseDown,
            .leftMouseUp,
            .rightMouseDown,
            .rightMouseUp,
            .otherMouseDown,
            .otherMouseUp,
            .scrollWheel
        ]
        NSEvent.addGlobalMonitorForEvents(matching: nsEventMaskList) {(event: NSEvent) -> Void in
            self.keyCode = nil
        }
        NSEvent.addLocalMonitorForEvents(matching: nsEventMaskList) {(event: NSEvent) -> NSEvent? in
            self.keyCode = nil
            return event
        }
        let eventMaskList = [
            CGEventType.scrollWheel.rawValue,
            CGEventType.leftMouseDown.rawValue,
            CGEventType.leftMouseUp.rawValue,
            CGEventType.keyDown.rawValue,
            CGEventType.keyUp.rawValue,
            CGEventType.flagsChanged.rawValue,
            UInt32(NX_SYSDEFINED) // Media key Event
        ]
        var eventMask: UInt32 = 0
        for mask in eventMaskList {
            eventMask |= (1 << mask)
        }
        let observer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? in
                if let observer = refcon {
                    let mySelf = Unmanaged<KeyEvent>.fromOpaque(observer).takeUnretainedValue()
                    return mySelf.eventCallback(proxy: proxy, type: type, event: event)
                }
                return Unmanaged.passUnretained(event)
        },
            userInfo: observer
            ) else {
                print("failed to create event tap")
                exit(1)
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
    
        if let mediaKeyEvent = MediaKeyEvent(event) {
            return mediaKeyEvent.keyDown ? mediaKeyDown(mediaKeyEvent) : mediaKeyUp(mediaKeyEvent)
        }
        
        
        switch type {
        case .flagsChanged:
            let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
            if modifierMasks[keyCode] == nil {
                return Unmanaged.passUnretained(event)
            }
            return event.flags.rawValue & modifierMasks[keyCode]!.rawValue != 0 ?
                modifierKeyDown(event) : modifierKeyUp(event)
        case .keyDown:
            return keyDown(event)
        case .keyUp:
            return keyUp(event)
        case .scrollWheel:
            if flags.contains(.maskCommand) {
                event.flags.insert(.maskCommand)
            }
            return Unmanaged.passUnretained(event)
        case .leftMouseDown:
            if flags.contains(.maskCommand) {
                event.flags.insert(.maskCommand)
            }
            return Unmanaged.passUnretained(event)
        case .leftMouseUp:
            if flags.contains(.maskCommand) {
                event.flags.insert(.maskCommand)
            }
            return Unmanaged.passUnretained(event)
        default:
            self.keyCode = nil
            return Unmanaged.passUnretained(event)
        }
    }

    func open(_ url: URL) {
        NSWorkspace.shared.open(url)

        if let app = NSWorkspace.shared.runningApplications
            .filter ({ (app: NSRunningApplication) in app.activationPolicy == NSApplication.ActivationPolicy.regular })
            .filter ({ (app: NSRunningApplication) in app.bundleURL == url}).first
        {
            app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        }
    }
    
    
    var on = false
    
    
    var flags = CGEventFlags()
    
    func keyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        print("kd: \(event.keyCode)")
        
        switch event.keyCode {
        case 122: // f1
            if #available(macOS 10.15, *) {
                open(URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app"))
            } else {
                open(URL(fileURLWithPath: "/Applications/Utilities/Terminal.app"))
            }
            return nil
        case 120: // f2

            open(URL(fileURLWithPath: "/System/Library/CoreServices/Finder.app"))
            return nil
        case 99: // f3
            open(URL(fileURLWithPath: "/Applications/Safari.app"))
            return nil
        case 118: // f4
            open(URL(fileURLWithPath: "/Applications/Numbers.app"))
            return nil
            
        case 96: // f5
            open(URL(fileURLWithPath: "/Applications/Xcode.app"))
            return nil
        case 97: // f6
            open(URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"))
            return nil

        case 98: // f7
            open(URL(fileURLWithPath: "/Applications/MacVim.app"))
            return nil

        case 100: // f8
            break
        case 101: // f9
            break
        case 109: // f10
            break
        case 103: // f11
            break
        case 111: // f12
            open(URL(fileURLWithPath: "/Users/user0x01/Z/bin/f12"))
            return nil

        case 102: // eiji left
            if !flags.contains(.maskCommand) {
                flags.insert(.maskCommand)
            }
            return nil
//        case 36: // enter -> /|
//            event.setIntegerValueField(.keyboardEventKeycode, value: 42)
//        case 42: //  \| -> enter
//            event.setIntegerValueField(.keyboardEventKeycode, value: 36)
        case 93:
            event.setIntegerValueField(.keyboardEventKeycode, value: 51)
        case 94:
            event.setIntegerValueField(.keyboardEventKeycode, value: 50)
        default:
            if flags.contains(.maskCommand) {
                event.flags.insert(.maskCommand)
            }
        }
        
        return Unmanaged.passUnretained(event)
    }
    func keyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
       
        switch event.keyCode {
        case 122: // f1
            return nil
        case 120: // f2
            return nil
        case 99: // f3
            return nil
        case 118: // f4
            return nil
        case 96: // f5
            return nil
        case 97: // f6
            return nil
        case 98: // f7
            return nil
        case 100: // f8
            break
        case 101: // f9
            break
        case 109: // f10
            break
        case 103: // f11
            break
        case 111: // f12
            return nil
        case 102:
            flags.remove(.maskCommand)
            return nil
//        case 36:
//            event.setIntegerValueField(.keyboardEventKeycode, value: 42)
//        case 42:
//            event.setIntegerValueField(.keyboardEventKeycode, value: 36)
        case 93:
            event.setIntegerValueField(.keyboardEventKeycode, value: 51)
        case 94:
            event.setIntegerValueField(.keyboardEventKeycode, value: 50)
        default:
            break
        }
        
        return Unmanaged.passUnretained(event)
    }
    func modifierKeyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {


        return Unmanaged.passUnretained(event)
    }
    func modifierKeyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {

        return Unmanaged.passUnretained(event)
    }
    func mediaKeyDown(_ mediaKeyEvent: MediaKeyEvent) -> Unmanaged<CGEvent>? {

        return Unmanaged.passUnretained(mediaKeyEvent.event)
    }
    func mediaKeyUp(_ mediaKeyEvent: MediaKeyEvent) -> Unmanaged<CGEvent>? {
        print("mediaKeyUp: \(mediaKeyEvent)")

        // if hasConvertedEvent(mediaKeyEvent.event, keyCode: CGKeyCode(1000 + mediaKeyEvent.keyCode)) {
        // if let event = getConvertedEvent(mediaKeyEvent.event, keyCode: CGKeyCode(1000 + Int(mediaKeyEvent.keyCode))) {
        // event.post(tap: CGEventTapLocation.cghidEventTap)
        // }
        // return nil
        // }
        return Unmanaged.passUnretained(mediaKeyEvent.event)
    }
    func hasConvertedEvent(_ event: CGEvent, keyCode: CGKeyCode? = nil) -> Bool {
//        let shortcut = event.isMediaEvent ?
//            KeyboardShortcut(keyCode: 0, flags: MediaKeyEvent(event)!.flags) : KeyboardShortcut(event)
//
//        if shortcut.keyCode == eiji {
//            var event = event
//            if event.isMediaEvent {
//                let flags = MediaKeyEvent(event)!.flags
//                event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true)!
//                event.flags = flags
//            }
//            let shortcht = KeyboardShortcut(event)
//            func getEvent(_ mappings: KeyMapping) -> CGEvent? {
//                if mappings.output.keyCode == 999 {
//                    // 999 is Disable
//                    return nil
//                }
//                event.setIntegerValueField(.keyboardEventKeycode, value: Int64(mappings.output.keyCode))
//                event.flags = CGEventFlags(
//                    rawValue: (event.flags.rawValue & ~mappings.input.flags.rawValue) | mappings.output.flags.rawValue
//                )
//                return event
//            }
//            if let mappingList = shortcutList[keyCode ?? shortcht.keyCode] {
//                if let mappings = hasConvertedEventLog,
//                    shortcht.isCover(mappings.input) {
//                    return getEvent(mappings)
//                }
//                for mappings in mappingList {
//                    if shortcht.isCover(mappings.input) {
//                        return getEvent(mappings)
//                    }
//                }
//            }
//            return nil
//        }
        
        return false
    }
    
    func getConvertedEvent(_ event: CGEvent, keyCode: CGKeyCode? = nil) -> CGEvent? {
//        var event = event
//        if event.isMediaEvent {
//            let flags = MediaKeyEvent(event)!.flags
//            event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true)!
//            event.flags = flags
//        }
//        let shortcht = KeyboardShortcut(event)
//        func getEvent(_ mappings: KeyMapping) -> CGEvent? {
//            if mappings.output.keyCode == 999 {
//                // 999 is Disable
//                return nil
//            }
//            event.setIntegerValueField(.keyboardEventKeycode, value: Int64(mappings.output.keyCode))
//            event.flags = CGEventFlags(
//                rawValue: (event.flags.rawValue & ~mappings.input.flags.rawValue) | mappings.output.flags.rawValue
//            )
//            return event
//        }
//        if let mappingList = shortcutList[keyCode ?? shortcht.keyCode] {
//            if let mappings = hasConvertedEventLog,
//                shortcht.isCover(mappings.input) {
//                return getEvent(mappings)
//            }
//            for mappings in mappingList {
//                if shortcht.isCover(mappings.input) {
//                    return getEvent(mappings)
//                }
//            }
//        }
        return nil
    }
}

let modifierMasks: [CGKeyCode: CGEventFlags] = [
    54: CGEventFlags.maskCommand,
    55: CGEventFlags.maskCommand,
    56: CGEventFlags.maskShift,
    60: CGEventFlags.maskShift,
    59: CGEventFlags.maskControl,
    62: CGEventFlags.maskControl,
    58: CGEventFlags.maskAlternate,
    61: CGEventFlags.maskAlternate,
    63: CGEventFlags.maskSecondaryFn,
    57: CGEventFlags.maskAlphaShift
]


class MediaKeyEvent: NSObject {
    let event: CGEvent
    let nsEvent: NSEvent
    var keyCode: Int
    var flags: CGEventFlags
    var keyDown: Bool
    init?(_ event: CGEvent) {
        guard event.isMediaEvent else {
            return nil
        }
        
        guard let nsEvent = NSEvent(cgEvent: event), nsEvent.subtype == .screenChanged else {
            return nil
        }
        
        self.nsEvent = nsEvent
        self.event = event
        keyCode = (nsEvent.data1 & 0xffff0000) >> 16
        flags = event.flags
        keyDown = ((nsEvent.data1 & 0xff00) >> 8) == 0xa
        
        super.init()
    }
}

let mediaKeyDic = [
    NX_KEYTYPE_SOUND_UP: "Sound_up",
    NX_KEYTYPE_SOUND_DOWN: "Sound_down",
    NX_KEYTYPE_BRIGHTNESS_UP: "Brightness_up",
    NX_KEYTYPE_BRIGHTNESS_DOWN: "Brightness_down",
    NX_KEYTYPE_CAPS_LOCK: "CapsLock",
    NX_KEYTYPE_HELP: "HELP",
    NX_POWER_KEY: "PowerKey",
    NX_KEYTYPE_MUTE: "mute",
    NX_KEYTYPE_NUM_LOCK: "NUM_LOCK",
    NX_KEYTYPE_CONTRAST_UP: "CONTRAST_UP",
    NX_KEYTYPE_CONTRAST_DOWN: "CONTRAST_DOWN",
    NX_KEYTYPE_LAUNCH_PANEL: "LAUNCH_PANEL",
    NX_KEYTYPE_EJECT: "EJECT",
    NX_KEYTYPE_VIDMIRROR: "VIDMIRROR",
    NX_KEYTYPE_PLAY: "Play",
    NX_KEYTYPE_NEXT: "NEXT",
    NX_KEYTYPE_PREVIOUS: "PREVIOUS",
    NX_KEYTYPE_FAST: "Fast",
    NX_KEYTYPE_REWIND: "Rewind",
    NX_KEYTYPE_ILLUMINATION_UP: "Illumination_up",
    NX_KEYTYPE_ILLUMINATION_DOWN: "Illumination_down",
    NX_KEYTYPE_ILLUMINATION_TOGGLE: "ILLUMINATION_TOGGLE"
]



class KeyboardShortcut: NSObject {
    var keyCode: CGKeyCode
    var flags: CGEventFlags
    init(_ event: CGEvent) {
        self.keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
        self.flags = event.flags
        super.init()
    }
    override init() {
        self.keyCode = 0
        self.flags = CGEventFlags(rawValue: 0)
        super.init()
    }
    init(keyCode: CGKeyCode, flags: CGEventFlags = CGEventFlags()) {
        self.keyCode = keyCode
        self.flags = flags
        super.init()
    }
    init?(dictionary: [AnyHashable: Any]) {
        if let keyCodeInt = dictionary["keyCode"] as? Int,
            let eventFlagsInt = dictionary["flags"] as? Int {
            self.flags = CGEventFlags(rawValue: UInt64(eventFlagsInt))
            self.keyCode = CGKeyCode(keyCodeInt)
            super.init()
        } else {
            self.keyCode = 0
            self.flags = CGEventFlags(rawValue: 0)
            super.init()
            return nil
        }
    }
    func toDictionary() -> [AnyHashable: Any] {
        return [
            "keyCode": Int(keyCode),
            "flags": Int(flags.rawValue)
        ]
    }
    func toString() -> String {
        let key = keyCodeDictionary[keyCode]
        if key == nil {
            return ""
        }
        var flagString = ""
        if isSecondaryFnDown() {
            flagString += "(fn)"
        }
        if isCapslockDown() {
            flagString += "⇪"
        }
        if isCommandDown() {
            flagString += "⌘"
        }
        if isShiftDown() {
            flagString += "⇧"
        }
        if isControlDown() {
            flagString += "⌃"
        }
        if isAlternateDown() {
            flagString += "⌥"
        }
        return flagString + key!
    }
    func isCommandDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskCommand.rawValue != 0 && keyCode != 54 && keyCode != 55
    }
    func isShiftDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskShift.rawValue != 0 && keyCode != 56 && keyCode != 60
    }
    func isControlDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskControl.rawValue != 0 && keyCode != 59 && keyCode != 62
    }
    func isAlternateDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskAlternate.rawValue != 0 && keyCode != 58 && keyCode != 61
    }
    func isSecondaryFnDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskSecondaryFn.rawValue != 0 && keyCode != 63
    }
    func isCapslockDown() -> Bool {
        return self.flags.rawValue & CGEventFlags.maskAlphaShift.rawValue != 0 && keyCode != 57
    }
    func postEvent() -> Void {
        let loc = CGEventTapLocation.cghidEventTap
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!
        keyDownEvent.flags = flags
        keyUpEvent.flags = CGEventFlags()
        keyDownEvent.post(tap: loc)
        keyUpEvent.post(tap: loc)
    }
    func isCover(_ shortcut: KeyboardShortcut) -> Bool {
        if shortcut.isCommandDown() && !self.isCommandDown() ||
            shortcut.isShiftDown() && !self.isShiftDown() ||
            shortcut.isControlDown() && !self.isControlDown() ||
            shortcut.isAlternateDown() && !self.isAlternateDown() ||
            shortcut.isSecondaryFnDown() && !self.isSecondaryFnDown() ||
            shortcut.isCapslockDown() && !self.isCapslockDown()
        {
            return false
        }
        return true
    }
}

func pk(_ key: CGKeyCode) {
    print("\(key): \(keyCodeDictionary[key])")
}

let keyCodeDictionary: Dictionary<CGKeyCode, String> = [
    0: "A",
    1: "S",
    2: "D",
    3: "F",
    4: "H",
    5: "G",
    6: "Z",
    7: "X",
    8: "C",
    9: "V",
    10: "DANISH_DOLLAR",
    11: "B",
    12: "Q",
    13: "W",
    14: "E",
    15: "R",
    16: "Y",
    17: "T",
    18: "1",
    19: "2",
    20: "3",
    21: "4",
    22: "6",
    23: "5",
    24: "=",
    25: "9",
    26: "7",
    27: "-",
    28: "8",
    29: "0",
    30: "]",
    31: "O",
    32: "U",
    33: "[",
    34: "I",
    35: "P",
    36: "⏎",
    37: "L",
    38: "J",
    39: "'",
    40: "K",
    41: ";",
    42: "\\",
    43: ",",
    44: "/",
    45: "N",
    46: "M",
    47: ".",
    48: "⇥",
    49: "Space",
    50: "`",
    51: "⌫",
    52: "Enter_POWERBOOK",
    53: "⎋",
    54: "Command_R",
    55: "Command_L",
    56: "Shift_L",
    57: "CapsLock",
    58: "Option_L",
    59: "Control_L",
    60: "Shift_R",
    61: "Option_R",
    62: "Control_R",
    63: "Fn",
    64: "F17",
    65: "Keypad_Dot",
    67: "Keypad_Multiply",
    69: "Keypad_Plus",
    71: "Keypad_Clear",
    75: "Keypad_Slash",
    76: "⌤",
    78: "Keypad_Minus",
    79: "F18",
    80: "F19",
    81: "Keypad_Equal",
    82: "Keypad_0",
    83: "Keypad_1",
    84: "Keypad_2",
    85: "Keypad_3",
    86: "Keypad_4",
    87: "Keypad_5",
    88: "Keypad_6",
    89: "Keypad_7",
    90: "F20",
    91: "Keypad_8",
    92: "Keypad_9",
    93: "¥",
    94: "_",
    95: "Keypad_Comma",
    96: "F5",
    97: "F6",
    98: "F7",
    99: "F3",
    100: "F8",
    101: "F9",
    102: "英数",
    103: "F11",
    104: "かな",
    105: "F13",
    106: "F16",
    107: "F14",
    109: "F10",
    110: "App",
    111: "F12",
    113: "F15",
    114: "Help",
    115: "Home", // "↖",
    116: "PgUp",
    117: "⌦",
    118: "F4",
    119: "End", // "↘",
    120: "F2",
    121: "PgDn",
    122: "F1",
    123: "←",
    124: "→",
    125: "↓",
    126: "↑",
    127: "PC_POWER",
    128: "GERMAN_PC_LESS_THAN",
    130: "DASHBOARD",
    131: "Launchpad",
    144: "BRIGHTNESS_UP",
    145: "BRIGHTNESS_DOWN",
    160: "Expose_All",
    // media key (bata)
    999: "Disable",
    1000 + UInt16(NX_KEYTYPE_SOUND_UP): "Sound_up",
    1000 + UInt16(NX_KEYTYPE_SOUND_DOWN): "Sound_down",
    1000 + UInt16(NX_KEYTYPE_BRIGHTNESS_UP): "Brightness_up",
    1000 + UInt16(NX_KEYTYPE_BRIGHTNESS_DOWN): "Brightness_down",
    1000 + UInt16(NX_KEYTYPE_CAPS_LOCK): "CapsLock",
    1000 + UInt16(NX_KEYTYPE_HELP): "HELP",
    1000 + UInt16(NX_POWER_KEY): "PowerKey",
    1000 + UInt16(NX_KEYTYPE_MUTE): "mute",
    1000 + UInt16(NX_KEYTYPE_NUM_LOCK): "NUM_LOCK",
    1000 + UInt16(NX_KEYTYPE_CONTRAST_UP): "CONTRAST_UP",
    1000 + UInt16(NX_KEYTYPE_CONTRAST_DOWN): "CONTRAST_DOWN",
    1000 + UInt16(NX_KEYTYPE_LAUNCH_PANEL): "LAUNCH_PANEL",
    1000 + UInt16(NX_KEYTYPE_EJECT): "EJECT",
    1000 + UInt16(NX_KEYTYPE_VIDMIRROR): "VIDMIRROR",
    1000 + UInt16(NX_KEYTYPE_PLAY): "Play",
    1000 + UInt16(NX_KEYTYPE_NEXT): "NEXT",
    1000 + UInt16(NX_KEYTYPE_PREVIOUS): "PREVIOUS",
    1000 + UInt16(NX_KEYTYPE_FAST): "Fast",
    1000 + UInt16(NX_KEYTYPE_REWIND): "Rewind",
    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_UP): "Illumination_up",
    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_DOWN): "Illumination_down",
    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_TOGGLE): "ILLUMINATION_TOGGLE"
]

extension CGEvent {
    var isMediaEvent: Bool {
        return type.rawValue == UInt32(NX_SYSDEFINED)
    }
    var keyCode: Int {
        return Int(getIntegerValueField(.keyboardEventKeycode))
    }
    
}

// key 93   ->  key deleteback(51)
// key 36 (enter)  -> key \|
// key 42 ()  -> key enter (36)
// key 102 () -> modifier 55
// key 94 () -> key ~｀

extension CGEventFlags {

}
