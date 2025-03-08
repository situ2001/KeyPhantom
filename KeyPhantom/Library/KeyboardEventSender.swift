//
//  KeyboardEventSender.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 23/2/2025.
//

import AppKit
import CoreFoundation
import CoreGraphics
import Foundation

/// A class to send keyboard events to specific applications.
class KeyboardEventSender {
    static let shared = KeyboardEventSender()

    // !! Should use privaite state to avoid confilction of the hidSystem one.
    private let eventSource = CGEventSource(stateID: .privateState)

    private init() {}

    public func send(key keyBoardKey: KeyboardKey, to appURL: URL) {
        let appListMgr = AppListManager.shared

        let appItem = appListMgr.getAppItem(from: appURL)

        if appItem != nil {
            self.send(key: keyBoardKey, to: appItem!)
        }
    }

    public func send(key keyBoardKey: KeyboardKey, to app: AppItem) {
        // Check accessibility permission
        AccessibilityManager.shared.checkAccessibility()
        
        let code = keyBoardKey.keyCode

        // construct a key down and key up event, to simulate a key press
        let keyDown = CGEvent(
            keyboardEventSource: eventSource, virtualKey: CGKeyCode(code),
            keyDown: true
        )

        // TODO: preserve the modifier flags
        //        var eventFlags: CGEventFlags = []
        //        if keyBoardKey.modifierFlags.contains(.shift) {
        //            eventFlags.insert(.maskShift)
        //        }
        //        keyDown?.flags = eventFlags

        let keyUp = CGEvent(
            keyboardEventSource: eventSource, virtualKey: CGKeyCode(code),
            keyDown: false)

        // set the target app, try to get
        let pid = getPidFromRunningApplicationBy(
            bundleIdentifier: app.bundleIdentifier)

        #if DEBUG
            print("pid: \(String(describing: pid))")
        #endif

        if pid == nil {
            // TODO: throw an error
        } else {
            #if DEBUG
                print("sending key event to \(app.bundleIdentifier)")
            #endif

            keyDown?.postToPid(pid!)
            keyUp?.postToPid(pid!)

            #if DEBUG
                print("key event sent")
            #endif
        }
    }

    private func getPidFromRunningApplicationBy(bundleIdentifier: String)
        -> pid_t?
    {
        let workspace = NSWorkspace.shared
        let apps = workspace.runningApplications

        let targetApp = apps.first { appItem in
            appItem.bundleIdentifier == bundleIdentifier
        }

        if targetApp == nil {
            return nil
        }

        return targetApp!.processIdentifier
    }
}
