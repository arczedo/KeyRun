//
//  File.swift
//  
//
//  Created by JPZ3562 on 2021/08/29.
//

import Foundation
import KeyRun_core
class KeyEvent_ja: KeyEvent {
    override func keyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        let r = super.keyDown(event)
        switch event.keyCode {
            case 102: // eiji left
                if !flags.contains(.maskCommand) {
                    flags.insert(.maskCommand)
                }
                return nil
            case 93:
                event.setIntegerValueField(.keyboardEventKeycode, value: 51)
                return Unmanaged.passUnretained(event)
            case 94:
                event.setIntegerValueField(.keyboardEventKeycode, value: 50)
                return Unmanaged.passUnretained(event)
            case keyCodeDictionary["H"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 123)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)

                }
            case keyCodeDictionary["L"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 124)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            case keyCodeDictionary["J"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 125)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            case keyCodeDictionary["K"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 126)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            default:
                if flags.contains(.maskCommand) {
                    event.flags.insert(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
        }
        return r
    }
    
    override func keyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        let r = super.keyDown(event)
        switch event.keyCode {
            case 102:
                flags.remove(.maskCommand)
                return nil
//            case 36:
//                event.setIntegerValueField(.keyboardEventKeycode, value: 42)
//            case 42:
//                event.setIntegerValueField(.keyboardEventKeycode, value: 36)
            case 93:
                event.setIntegerValueField(.keyboardEventKeycode, value: 51)
                return Unmanaged.passUnretained(event)
            case 94:
                event.setIntegerValueField(.keyboardEventKeycode, value: 50)
                return Unmanaged.passUnretained(event)
            case keyCodeDictionary["H"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 123)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            case keyCodeDictionary["L"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 124)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            case keyCodeDictionary["J"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 125)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            case keyCodeDictionary["K"]!:
                if flags.contains(.maskCommand) {
                    event.setIntegerValueField(.keyboardEventKeycode, value: 126)
                    event.flags.remove(.maskCommand)
                    return Unmanaged.passUnretained(event)
                }
            default:
                break
        }
        return r
    }
}
