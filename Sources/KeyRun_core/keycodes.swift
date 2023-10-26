//
//  keycods.swift
//  L
//
//  Created by JPZ3562 on 2021/11/07.
//

import Carbon

enum KeyCode: CGKeyCode, CaseIterable, Identifiable, Codable, Hashable {

    // ----------------------------------------
    // alphabet
    case a                       = 0   // 0x0
    case b                       = 11  // 0xb
    case c                       = 8   // 0x8
    case d                       = 2   // 0x2
    case e                       = 14  // 0xe
    case f                       = 3   // 0x3
    case g                       = 5   // 0x5
    case h                       = 4   // 0x4
    case i                       = 34  // 0x22
    case j                       = 38  // 0x26
    case k                       = 40  // 0x28
    case l                       = 37  // 0x25
    case m                       = 46  // 0x2e
    case n                       = 45  // 0x2d
    case o                       = 31  // 0x1f
    case p                       = 35  // 0x23
    case q                       = 12  // 0xc
    case r                       = 15  // 0xf
    case s                       = 1   // 0x1
    case t                       = 17  // 0x11
    case u                       = 32  // 0x20
    case v                       = 9   // 0x9
    case w                       = 13  // 0xd
    case x                       = 7   // 0x7
    case y                       = 16  // 0x10
    case z                       = 6   // 0x6

    // ----------------------------------------
    // number
    case n0                      = 29  // 0x1d
    case n1                      = 18  // 0x12
    case n2                      = 19  // 0x13
    case n3                      = 20  // 0x14
    case n4                      = 21  // 0x15
    case n5                      = 23  // 0x17
    case n6                      = 22  // 0x16
    case n7                      = 26  // 0x1a
    case n8                      = 28  // 0x1c
    case n9                      = 25  // 0x19

    // ----------------------------------------
    // symbol
    // BACKQUOTE is also known as grave accent or backtick.
    case backquote               = 50  // 0x32
    case backslash               = 42  // 0x2a
    case bracketLeft             = 33  // 0x21
    case bracketRight            = 30  // 0x1e
    case comma                   = 43  // 0x2b ,
    case dot                     = 47  // 0x2f
    case equal                   = 24  // 0x18
    case minus                   = 27  // 0x1b
    case quote                   = 39  // 0x27
    case semicolon               = 41  // 0x29 ;
    case slash                   = 44  // 0x2c

    // ----------------------------------------
    // keypad
    case keypad0                 = 82  // 0x52
    case keypad1                 = 83  // 0x53
    case keypad2                 = 84  // 0x54
    case keypad3                 = 85  // 0x55
    case keypad4                 = 86  // 0x56
    case keypad5                 = 87  // 0x57
    case keypad6                 = 88  // 0x58
    case keypad7                 = 89  // 0x59
    case keypad8                 = 91  // 0x5b
    case keypad9                 = 92  // 0x5c
    case keypadClear             = 71  // 0x47
    case keypadComma             = 95  // 0x5f
    case keypadDot               = 65  // 0x41
    case keypadEqual             = 81  // 0x51
    case keypadMinus             = 78  // 0x4e
    case keypadMultiply          = 67  // 0x43
    case keypadPlus              = 69  // 0x45
    case keypadSlash             = 75  // 0x4b

    // ----------------------------------------
    // special
    case delete                  = 51  // 0x33
    case enter                   = 76  // 0x4c
    case enterPowerbook          = 52  // 0x34
    case escape                  = 53  // 0x35
    case forwardDelete           = 117 // 0x75
    case help                    = 114 // 0x72
    case `return`                = 36  // 0x24
    case space                   = 49  // 0x31
    case tab                     = 48  // 0x30

    // ----------------------------------------
    // function
    case f1                      = 122 // 0x7a
    case f2                      = 120 // 0x78
    case f3                      = 99  // 0x63
    case f4                      = 118 // 0x76
    case f5                      = 96  // 0x60
    case f6                      = 97  // 0x61
    case f7                      = 98  // 0x62
    case f8                      = 100 // 0x64
    case f9                      = 101 // 0x65
    case f10                     = 109 // 0x6d
    case f11                     = 103 // 0x67
    case f12                     = 111 // 0x6f
    case f13                     = 105 // 0x69
    case f14                     = 107 // 0x6b
    case f15                     = 113 // 0x71
    case f16                     = 106 // 0x6a
    case f17                     = 64  // 0x40
    case f18                     = 79  // 0x4f
    case f19                     = 80  // 0x50

    // ----------------------------------------
    // functional
    case brightnessDown          = 145 // 0x91
    case brightnessUp            = 144 // 0x90
    case dashboard               = 130 // 0x82
//    case exposeAll               = 160 // 0xa0
    case launchpad               = 131 // 0x83
    case missionControl          = 160 // 0xa0

    // ----------------------------------------
    // cursor
    case up                      = 126 // 0x7e
    case down                    = 125 // 0x7d
    case left                    = 123 // 0x7b
    case right                   = 124 // 0x7c
    case pageup                  = 116 // 0x74
    case pagedown                = 121 // 0x79
    case home                    = 115 // 0x73
    case end                     = 119 // 0x77

    // ----------------------------------------
    // modifiers
    case capslock                = 57  // 0x39
    case commandL                = 55  // 0x37
    case commandR                = 54  // 0x36
    case controlL                = 59  // 0x3b
    case controlR                = 62  // 0x3e
    case fn                      = 63  // 0x3f
    case optionL                 = 58  // 0x3a
    case optionR                 = 61  // 0x3d
    case shiftL                  = 56  // 0x38
    case shiftR                  = 60  // 0x3c

    // ----------------------------------------
    // pc keyboard
//    case pcApplication           = 110 // 0x6e
//    case pcBs                    = 51  // 0x33
//    case pcDel                   = 117 // 0x75
//    case pcInsert                = 114 // 0x72
//    case pcKeypadNumlock         = 71  // 0x47
//    case pcPause                 = 113 // 0x71
//    case pcPower                 = 127 // 0x7f
//    case pcPrintscreen           = 105 // 0x69
//    case pcScrolllock            = 107 // 0x6b

    // ----------------------------------------
    // international
//    case danishDollar            = 10  // 0xa
//    case danishLessThan          = 50  // 0x32
//    case frenchDollar            = 30  // 0x1e
//    case frenchEqual             = 44  // 0x2c
//    case frenchHat               = 33  // 0x21
//    case frenchMinus             = 24  // 0x18
//    case frenchRightParen        = 27  // 0x1b
//    case germanCircumflex        = 10  // 0xa
//    case germanLessThan          = 50  // 0x32
//    case germanPcLessThan        = 128 // 0x80
//    case germanQuote             = 24  // 0x18
//    case germanAUmlaut           = 39  // 0x27
//    case germanOUmlaut           = 41  // 0x29
//    case germanUUmlaut           = 33  // 0x21
//    case italianBackslash        = 10  // 0xa
//    case italianLessThan         = 50  // 0x32
//    case jisAtmark               = 33  // 0x21
//    case jisBracketLeft          = 30  // 0x1e
//    case jisBracketRight         = 42  // 0x2a
//    case jisColon                = 39  // 0x27
//    case jisDakuon               = 33  // 0x21
    case jisEisuu                = 102   // 0x66
//    case jisHandakuon            = 30  // 0x1e 半濁音
//    case jisHat                  = 24  // 0x18
    case jisKana                 = 104   // 0x68
//    case jisPcHanZen             = 50  // 0x32 半/全
    case jisUnderscore           = 94    // 0x5e
    case jisYen                  = 93    // 0x5d
//    case russianParagraph        = 10  // 0xa
//    case russianTilde            = 50  // 0x32
//    case spanishLessThan         = 50  // 0x32
//    case spanishOrdinalIndicator = 10  // 0xa
//    case swedishLessThan         = 50  // 0x32
//    case swedishSection          = 10  // 0xa
//    case swissLessThan           = 50  // 0x32
//    case swissSection            = 10  // 0xa
//    case ukSection               = 10  // 0xa

    // ----------------------------------------
    // Reserved for user: 0x10000 - 0xFFFFFFF
    //
    // User can define own key code in private.xml:
    // <symbol_map type="KeyCode" name="PRIVATE_SIMULTANEOUS_WE" value="0x10001" />
    // <symbol_map type="KeyCode" name="PRIVATE_SIMULTANEOUS_ER" value="0x10002" />
    //
    // ----------------------------------------
    // Virtual KeyCode
//    case vkBegin                 = 268435456       // 0x10000000

//    case soundUp                   = (1000 + UInt16(NX_KEYTYPE_SOUND_UP))
    //    1000 + UInt16(NX_KEYTYPE_SOUND_UP): "Sound_up",
    //    1000 + UInt16(NX_KEYTYPE_SOUND_DOWN): "Sound_down",
    //    1000 + UInt16(NX_KEYTYPE_BRIGHTNESS_UP): "Brightness_up",
    //    1000 + UInt16(NX_KEYTYPE_BRIGHTNESS_DOWN): "Brightness_down",
    //    1000 + UInt16(NX_KEYTYPE_CAPS_LOCK): "CapsLock",
    //    1000 + UInt16(NX_KEYTYPE_HELP): "HELP",
    //    1000 + UInt16(NX_POWER_KEY): "PowerKey",
    //    1000 + UInt16(NX_KEYTYPE_MUTE): "mute",
    //    1000 + UInt16(NX_KEYTYPE_NUM_LOCK): "NUM_LOCK",
    //    1000 + UInt16(NX_KEYTYPE_CONTRAST_UP): "CONTRAST_UP",
    //    1000 + UInt16(NX_KEYTYPE_CONTRAST_DOWN): "CONTRAST_DOWN",
    //    1000 + UInt16(NX_KEYTYPE_LAUNCH_PANEL): "LAUNCH_PANEL",
    //    1000 + UInt16(NX_KEYTYPE_EJECT): "EJECT",
    //    1000 + UInt16(NX_KEYTYPE_VIDMIRROR): "VIDMIRROR",
    //    1000 + UInt16(NX_KEYTYPE_PLAY): "Play",
    //    1000 + UInt16(NX_KEYTYPE_NEXT): "NEXT",
    //    1000 + UInt16(NX_KEYTYPE_PREVIOUS): "PREVIOUS",
    //    1000 + UInt16(NX_KEYTYPE_FAST): "Fast",
    //    1000 + UInt16(NX_KEYTYPE_REWIND): "Rewind",
    //    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_UP): "Illumination_up",
    //    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_DOWN): "Illumination_down",
    //    1000 + UInt16(NX_KEYTYPE_ILLUMINATION_TOGGLE): "ILLUMINATION_TOGGLE"

    /// human readable
    var hu: String {
        switch self {
            case .commandL, .commandR: return "⌘"
            case .optionL, .optionR: return "⌥"
            case .shiftL, .shiftR: return "⇧"
            case .controlL, .controlR: return "⌃"
            case .escape: return "⎋"
            case .capslock: return "⇪"
            case .`return`: return "⏎"
            case .delete: return "⌫"
            case .forwardDelete: return "⌦"
            case .tab: return "⇥"
            case .up: return "↑"
            case .down: return "↓"
            case .left: return "←"
            case .right: return "→"
            case .space: return "␣"
            case .n0: return "0"
            case .n1: return "1"
            case .n2: return "2"
            case .n3: return "3"
            case .n4: return "4"
            case .n5: return "5"
            case .n6: return "6"
            case .n7: return "7"
            case .n8: return "8"
            case .n9: return "9"
            default: return String(describing: self)
        }
    }

    var id: RawValue {
        rawValue
    }

    var title: String {
        "\(self)( \(hu) )"
    }

}


extension Key {
    init?(c: Character) {
        // s = ("1".."9").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s
        // s = ("a".."z").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s
        // s = ("A".."Z").map{|x| "case \"#{x}\": keyCode = .#{x.downcase}; modifier = .shift"};puts s

        // s = (" ".."/").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s
        // s = (":".."@").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s
        // s = ("[".."`").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s
        // s = ("{".."~").map{|x| "case \"#{x}\": keyCode = .#{x}"};puts s

        modifier = []
        switch c {
            case "0": keyCode = .n0
            case "1": keyCode = .n1
            case "2": keyCode = .n2
            case "3": keyCode = .n3
            case "4": keyCode = .n4
            case "5": keyCode = .n5
            case "6": keyCode = .n6
            case "7": keyCode = .n7
            case "8": keyCode = .n8
            case "9": keyCode = .n9

            case "a": keyCode = .a
            case "b": keyCode = .b
            case "c": keyCode = .c
            case "d": keyCode = .d
            case "e": keyCode = .e
            case "f": keyCode = .f
            case "g": keyCode = .g
            case "h": keyCode = .h
            case "i": keyCode = .i
            case "j": keyCode = .j
            case "k": keyCode = .k
            case "l": keyCode = .l
            case "m": keyCode = .m
            case "n": keyCode = .n
            case "o": keyCode = .o
            case "p": keyCode = .p
            case "q": keyCode = .q
            case "r": keyCode = .r
            case "s": keyCode = .s
            case "t": keyCode = .t
            case "u": keyCode = .u
            case "v": keyCode = .v
            case "w": keyCode = .w
            case "x": keyCode = .x
            case "y": keyCode = .y

            case "A": keyCode = .a; modifier = .shift
            case "B": keyCode = .b; modifier = .shift
            case "C": keyCode = .c; modifier = .shift
            case "D": keyCode = .d; modifier = .shift
            case "E": keyCode = .e; modifier = .shift
            case "F": keyCode = .f; modifier = .shift
            case "G": keyCode = .g; modifier = .shift
            case "H": keyCode = .h; modifier = .shift
            case "I": keyCode = .i; modifier = .shift
            case "J": keyCode = .j; modifier = .shift
            case "K": keyCode = .k; modifier = .shift
            case "L": keyCode = .l; modifier = .shift
            case "M": keyCode = .m; modifier = .shift
            case "N": keyCode = .n; modifier = .shift
            case "O": keyCode = .o; modifier = .shift
            case "P": keyCode = .p; modifier = .shift
            case "Q": keyCode = .q; modifier = .shift
            case "R": keyCode = .r; modifier = .shift
            case "S": keyCode = .s; modifier = .shift
            case "T": keyCode = .t; modifier = .shift
            case "U": keyCode = .u; modifier = .shift
            case "V": keyCode = .v; modifier = .shift
            case "W": keyCode = .w; modifier = .shift
            case "X": keyCode = .x; modifier = .shift
            case "Y": keyCode = .y; modifier = .shift
            case "Z": keyCode = .z; modifier = .shift

            case " ": keyCode = .space
            case "!": keyCode = .n1; modifier = .shift
            case "\"": keyCode = .quote; modifier = .shift
            case "#": keyCode = .n3; modifier = .shift
            case "$": keyCode = .n4; modifier = .shift
            case "%": keyCode = .n5; modifier = .shift
            case "&": keyCode = .n7; modifier = .shift
            case "'": keyCode = .quote
            case "(": keyCode = .n9; modifier = .shift
            case ")": keyCode = .n0; modifier = .shift
            case "*": keyCode = .n8; modifier = .shift
            case "+": keyCode = .equal; modifier = .shift
            case ",": keyCode = .comma
            case "-": keyCode = .minus
            case ".": keyCode = .dot
            case "/": keyCode = .slash

            case ":": keyCode = .semicolon; modifier = .shift
            case ";": keyCode = .semicolon
            case "<": keyCode = .comma; modifier = .shift
            case "=": keyCode = .equal
            case ">": keyCode = .dot; modifier = .shift
            case "?": keyCode = .slash; modifier = .shift
            case "@": keyCode = .n2; modifier = .shift

            case "[": keyCode = .bracketLeft
            case "\\": keyCode = .backslash
            case "]": keyCode = .bracketRight
            case "^": keyCode = .n6; modifier = .shift
            case "_": keyCode = .minus; modifier = .shift
            case "`": keyCode = .backquote

            case "{": keyCode = .bracketLeft; modifier = .shift
            case "|": keyCode = .backslash; modifier = .shift
            case "}": keyCode = .bracketRight; modifier = .shift
            case "~": keyCode = .backquote; modifier = .shift

            default: return nil
        }
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
