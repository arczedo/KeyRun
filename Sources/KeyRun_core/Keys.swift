//
//  File.swift
//  
//
//  Created by zedo zedo on 2023/10/26.
//

import Foundation
import CoreGraphics

extension CGEventFlags {
    var modifier: KeyModifier {
        [
            (CGEventFlags.maskCommand, KeyModifier.command)
            , (.maskShift, .shift)
            , (.maskControl, .control)
            , (.maskAlternate, .option)
        ]
            .reduce(into: KeyModifier()) {
                if contains($1.0) {$0.insert($1.1)}
            }
    }
}

struct KeyModifier: OptionSet, Codable, Hashable, CustomDebugStringConvertible {
    let rawValue: Int

    static let command = KeyModifier(rawValue: 1 << 0)
    static let shift = KeyModifier(rawValue: 1 << 1)
    static let option = KeyModifier(rawValue: 1 << 2)
    static let control = KeyModifier(rawValue: 1 << 3)

    var debugDescription: String {
        [KeyModifier.command, .shift, .control, .option]
            .compactMap { contains($0) ? $0.title : nil }
            .joined(separator: "|")
    }

    var title: String {
        switch self {
            case .command: KeyCode.commandL.hu
            case .shift: KeyCode.shiftL.hu
            case .option: KeyCode.optionL.hu
            case .control: KeyCode.controlL.hu
            default: ""
        }
    }
}

extension CGEventFlags: Codable {}

public struct KeyOp: Codable, Hashable {
    public enum Kind: Int, Codable {
        case up, down
    }

    public var key: Key
    public var kind: Kind

    public init(key: Key, kind: Kind) {
        self.key = key
        self.kind = kind
    }

    public init?(_ type: CGEventType, _ event: CGEvent) {
        switch type {
            case .keyUp:
                kind = .up
            case .keyDown:
                kind = .down
            default:
                return nil
        }

        guard let k = KeyCode(rawValue: event.keyCode) else { return nil }
        key = Key(keyCode: k, modifier: event.flags.modifier)
    }

}

extension KeyOp: CustomDebugStringConvertible {
    public var debugDescription: String {
        key.modifier.debugDescription 
        + ":"
        + key.keyCode.title
        + ":"
        + String(describing: kind)
    }
}

public struct Key: Codable, Hashable {
    var keyCode: KeyCode
    var modifier: KeyModifier
}
