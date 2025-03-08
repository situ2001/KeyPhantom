//
//  KeyBindingRowView.swift
//  KeyPhantom
//
//  Created by situ on 21/2/2025.
//

import AppKit
import KeyboardShortcuts
import SwiftUI

struct KeyBindingRowView: View {
    @Binding var keyBinding: KeyBinding

    @State private var isAppListViewPresented = false
    @State private var isDeleteAlertPresented = false

    // if nil, the key binding will not be updated
    // else, it will call the related method to update the key binding
    var keyBindingManager: KeyBindingManager? = nil

    var appItem: AppItem? {
        AppListManager.shared.getAppItem(from: keyBinding.targetApplication)
    }

    var body: some View {
        VStack {

            if keyBindingManager == nil {
                // List Header
                HStack(spacing: 0) {
                    Text("Shortcuts")
                        .frame(width: 150, alignment: .center)

                    Divider().frame(width: 1)

                    Text("Key Sent")
                        .frame(width: 150, alignment: .center)

                    Divider().frame(width: 1)

                    Text("To application")
                        .frame(width: 200, alignment: .center)

                    Divider().frame(width: 1)

                    Text("Enabled")
                        .frame(width: 100, alignment: .center)
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.15))
                .frame(height: 25)
            }

            HStack(spacing: 0) {
                // Display the shortcut key with a recorder
                KeyboardShortcuts.Recorder(
                    for: KeyboardShortcuts.Name(
                        keyBinding.shortcutKeyName)
                )
                .frame(width: 150, alignment: .center)

                Spacer().frame(width: 1)

                // Right arrow
                //            Image(systemName: "arrow.right")
                //                .foregroundColor(.gray)

                switch keyBinding.valueForEvent {
                case .keyDown(_):
                    KeyCodeView(
                        valueForEvent: keyBinding.valueForEvent,
                        onChange: { newValue in
                            keyBinding.valueForEvent = .keyDown(
                                KeyboardKey(keyCode: newValue))

                            // if keyBindingManager is not nil, update the key binding
                            self.keyBindingManager?.updateKeyBinding(keyBinding)
                        }
                    )
                    .frame(width: 150, alignment: .center)
                default:
                    Text("Unknown")
                        .frame(width: 150, alignment: .center)
                }

                Spacer().frame(width: 1)

                SelectedAppView(
                    appItem: self.appItem,
                    onSelected: { appItem in
                        // Actually update the target application
                        keyBinding.targetApplication = appItem.url

                        // delete if the key binding manager is not nil
                        self.keyBindingManager?.updateKeyBinding(keyBinding)

                        isAppListViewPresented = false
                    }
                )
                .frame(width: 200)

                Spacer().frame(width: 1)

                // Checkbox for enable/disable
                Toggle(
                    "",
                    isOn: Binding(
                        get: {
                            keyBinding.enabled
                        },
                        set: { newValue in
                            keyBinding.enabled = newValue
                            // if keyBindingManager is not nil, update the key binding
                            self.keyBindingManager?.updateKeyBinding(keyBinding)
                        }
                    )
                )
                .frame(width: 100, alignment: .center)

                Spacer().frame(width: 1)

                // Delete
                if let keyBindingManager = keyBindingManager {
                    Button {
                        isDeleteAlertPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .alert(
                        "Delete this key binding?",
                        isPresented: $isDeleteAlertPresented
                    ) {
                        Button("Delete", role: .destructive) {
                            keyBindingManager.deleteKeyBinding(keyBinding)
                            isDeleteAlertPresented = false
                        }
                    }
                    .frame(width: 100, alignment: .center)
                }
            }
            .frame(height: 25)
        }
    }
}
