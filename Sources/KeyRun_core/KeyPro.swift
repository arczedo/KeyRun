//
//  KeyPro.swift
//  KeyRun
//
//  Created by user01 on 2019/06/05.
//  Copyright © 2019 user01. All rights reserved.
//

import Cocoa
import Carbon
public func open(_ url: URL) {
    NSWorkspace.shared.open(url)

    if let app = NSWorkspace.shared.runningApplications
        .filter ({ (app: NSRunningApplication) in app.activationPolicy == NSApplication.ActivationPolicy.regular })
        .filter ({ (app: NSRunningApplication) in app.bundleURL == url}).first
    {
        app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
    }
}

public extension Dictionary where Value: Equatable {
    subscript(value: Value) -> Key? {
        first(where: { $1 == value })?.key
    }
}

open class KeyEvent: NSObject {
//    @Published var event: (type: CGEventType, event: CGEvent)?

    public var handler: ((_ type: CGEventType, _ event: CGEvent, _ flags: inout CGEventFlags) -> Unmanaged<CGEvent>?)?

    var keyCode: CGKeyCode? = nil
    var isExclusionApp = false
    //    let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    public override init() {
        super.init()
    }
    public func start() {
        if !AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary) {
            log1("Permission not granded.")
            // アクセシビリティに設定されていない場合、設定されるまでループで待つ
            Timer.scheduledTimer(timeInterval: 1.0,
                                 target: self,
                                 selector: #selector(KeyEvent.watchAXIsProcess(_:)),
                                 userInfo: nil,
                                 repeats: true)
        } else {
            watch()
        }
    }
    @objc func watchAXIsProcess(_ timer: Timer) {
        log1("watchAXIsProcess.\(Date())")
        if AXIsProcessTrusted() {
            log1("watchAXIsProcess trusted")

            timer.invalidate()
            watch()
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
            tap: .cghidEventTap,
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
            log6("failed to create event tap")
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
                return handler?(type, event, &flags)
            case .keyUp:
                return handler?(type, event, &flags)
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
                log3(type)
                keyCode = nil
                return Unmanaged.passUnretained(event)
        }
    }
    

    public var flags = CGEventFlags()
    
    open func keyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        log2("kd: \(event.keyCode)")
        switch event.keyCode {
            case 53: // esc
                open(URL(fileURLWithPath: "/Applications/L.app"))
                return nil
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
                open(URL(fileURLWithPath: "/Applications/Slack.app"))
                return nil
            case 101: // f9
                break
            case 109: // f10
                break
            case 103: // f11
                break
            case 111: // f12
                break
                
            case 102: // eiji left
                //            if !flags.contains(.maskCommand) {
                //                flags.insert(.maskCommand)
                //            }
                //            return nil
                //        case 36: // enter -> /|
                //            event.setIntegerValueField(.keyboardEventKeycode, value: 42)
                //        case 42: //  \| -> enter
                //            event.setIntegerValueField(.keyboardEventKeycode, value: 36)
                break
            case 93:
                //            event.setIntegerValueField(.keyboardEventKeycode, value: 51)
                break
            case 94:
                //            event.setIntegerValueField(.keyboardEventKeycode, value: 50)
                break
                
            
            default:
                //            if flags.contains(.maskCommand) {
                //                event.flags.insert(.maskCommand)
                //            }
                break
        }
        
        return Unmanaged.passUnretained(event)
    }
    open func keyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        
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
                open(URL(fileURLWithPath: "/Users/jpz3562/Z/W/prefs/macOS/zsh/f12/72"))
                return nil
            case 102:
                break
            //            flags.remove(.maskCommand)
            //            return nil
            //        case 36:
            //            event.setIntegerValueField(.keyboardEventKeycode, value: 42)
            //        case 42:
            //            event.setIntegerValueField(.keyboardEventKeycode, value: 36)
            case 93:
                break
            //            event.setIntegerValueField(.keyboardEventKeycode, value: 51)
            case 94:
                break
            //            event.setIntegerValueField(.keyboardEventKeycode, value: 50)
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
//        log4("mediaKeyUp: \(mediaKeyEvent)")

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

extension CGEvent {
    var isMediaEvent: Bool {
        return type.rawValue == UInt32(NX_SYSDEFINED)
    }
    public var keyCode: CGKeyCode {
        return CGKeyCode(getIntegerValueField(.keyboardEventKeycode))
    }
    
}

// key 93   ->  key deleteback(51)
// key 36 (enter)  -> key \|
// key 42 ()  -> key enter (36)
// key 102 () -> modifier 55
// key 94 () -> key ~｀

extension CGEventFlags {

}
