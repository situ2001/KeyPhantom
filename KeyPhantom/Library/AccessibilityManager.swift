//
//  AccessibilityManager.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 8/3/2025.
//

import Accessibility
import SwiftUI

class AccessibilityManager {
    var accessibilityEnabled = false

    static let shared = AccessibilityManager()

    private init() {
        checkAccessibility()
    }

    func checkAccessibility() {
        let checkOptPrompt =
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString

        let options: NSDictionary = [checkOptPrompt: true]

        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessibilityEnabled {
            print("Accessibility is not enabled")
        }

        self.accessibilityEnabled = accessibilityEnabled
    }
}
