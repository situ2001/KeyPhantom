//
//  KeyString.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 23/2/2025.
//

import Carbon.HIToolbox
import Foundation

/// I have exchanged the mapping of key and value based on the file `Key.swift` in repo https://github.com/sindresorhus/KeyboardShortcuts
extension KeyboardKey {
    private static let keyCodeToDescription: [Int: String] = [
        // Letters
        kVK_ANSI_A: "a",
        kVK_ANSI_B: "b",
        kVK_ANSI_C: "c",
        kVK_ANSI_D: "d",
        kVK_ANSI_E: "e",
        kVK_ANSI_F: "f",
        kVK_ANSI_G: "g",
        kVK_ANSI_H: "h",
        kVK_ANSI_I: "i",
        kVK_ANSI_J: "j",
        kVK_ANSI_K: "k",
        kVK_ANSI_L: "l",
        kVK_ANSI_M: "m",
        kVK_ANSI_N: "n",
        kVK_ANSI_O: "o",
        kVK_ANSI_P: "p",
        kVK_ANSI_Q: "q",
        kVK_ANSI_R: "r",
        kVK_ANSI_S: "s",
        kVK_ANSI_T: "t",
        kVK_ANSI_U: "u",
        kVK_ANSI_V: "v",
        kVK_ANSI_W: "w",
        kVK_ANSI_X: "x",
        kVK_ANSI_Y: "y",
        kVK_ANSI_Z: "z",

        // Numbers
        kVK_ANSI_0: "zero",
        kVK_ANSI_1: "one",
        kVK_ANSI_2: "two",
        kVK_ANSI_3: "three",
        kVK_ANSI_4: "four",
        kVK_ANSI_5: "five",
        kVK_ANSI_6: "six",
        kVK_ANSI_7: "seven",
        kVK_ANSI_8: "eight",
        kVK_ANSI_9: "nine",

        // Modifiers
        kVK_CapsLock: "capsLock",
        kVK_Shift: "shift",
        kVK_Function: "function",
        kVK_Control: "control",
        kVK_Option: "option",
        kVK_Command: "command",
        kVK_RightCommand: "rightCommand",
        kVK_RightOption: "rightOption",
        kVK_RightControl: "rightControl",
        kVK_RightShift: "rightShift",

        // Miscellaneous
        kVK_Return: "return",
        kVK_ANSI_Backslash: "backslash",
        kVK_ANSI_Grave: "backtick",
        kVK_ANSI_Comma: "comma",
        kVK_ANSI_Equal: "equal",
        kVK_ANSI_Minus: "minus",
        kVK_ANSI_Period: "period",
        kVK_ANSI_Quote: "quote",
        kVK_ANSI_Semicolon: "semicolon",
        kVK_ANSI_Slash: "slash",
        kVK_Space: "space",
        kVK_Tab: "tab",
        kVK_ANSI_LeftBracket: "leftBracket",
        kVK_ANSI_RightBracket: "rightBracket",
        kVK_PageUp: "pageUp",
        kVK_PageDown: "pageDown",
        kVK_Home: "home",
        kVK_End: "end",
        kVK_UpArrow: "upArrow",
        kVK_RightArrow: "rightArrow",
        kVK_DownArrow: "downArrow",
        kVK_LeftArrow: "leftArrow",
        kVK_Escape: "escape",
        kVK_Delete: "delete",
        kVK_ForwardDelete: "deleteForward",
        kVK_Help: "help",
        kVK_Mute: "mute",
        kVK_VolumeUp: "volumeUp",
        kVK_VolumeDown: "volumeDown",

        // Function Keys
        kVK_F1: "f1",
        kVK_F2: "f2",
        kVK_F3: "f3",
        kVK_F4: "f4",
        kVK_F5: "f5",
        kVK_F6: "f6",
        kVK_F7: "f7",
        kVK_F8: "f8",
        kVK_F9: "f9",
        kVK_F10: "f10",
        kVK_F11: "f11",
        kVK_F12: "f12",
        kVK_F13: "f13",
        kVK_F14: "f14",
        kVK_F15: "f15",
        kVK_F16: "f16",
        kVK_F17: "f17",
        kVK_F18: "f18",
        kVK_F19: "f19",
        kVK_F20: "f20",

        // Keypad
        kVK_ANSI_Keypad0: "keypad0",
        kVK_ANSI_Keypad1: "keypad1",
        kVK_ANSI_Keypad2: "keypad2",
        kVK_ANSI_Keypad3: "keypad3",
        kVK_ANSI_Keypad4: "keypad4",
        kVK_ANSI_Keypad5: "keypad5",
        kVK_ANSI_Keypad6: "keypad6",
        kVK_ANSI_Keypad7: "keypad7",
        kVK_ANSI_Keypad8: "keypad8",
        kVK_ANSI_Keypad9: "keypad9",
        kVK_ANSI_KeypadClear: "keypadClear",
        kVK_ANSI_KeypadDecimal: "keypadDecimal",
        kVK_ANSI_KeypadDivide: "keypadDivide",
        kVK_ANSI_KeypadEnter: "keypadEnter",
        kVK_ANSI_KeypadEquals: "keypadEquals",
        kVK_ANSI_KeypadMinus: "keypadMinus",
        kVK_ANSI_KeypadMultiply: "keypadMultiply",
        kVK_ANSI_KeypadPlus: "keypadPlus",
    ]

    // description of keycode
    var description: String {
        return Self.keyCodeToDescription[keyCode] ?? "unknown"
    }
}
