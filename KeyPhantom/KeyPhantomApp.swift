//
//  KeyPhantomApp.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 20/2/2025.
//

import LaunchAtLogin
import Sparkle
import SwiftUI

@main
struct KeyPhantomApp: App {
    private let updaterController: SPUStandardUpdaterController

    let persistenceController = PersistenceController.shared

    @StateObject private var keyBindingManager = KeyBindingManager(
        context: PersistenceController.shared.container.viewContext)

    private var accessibilityManager = AccessibilityManager.shared

    let appListManager = AppListManager.shared

    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil
        )
        
        // check Accessibility
        self.accessibilityManager.checkAccessibility()
    }

    @State private var selectedTab = 0

    var body: some Scene {
        Settings {
            TabView(selection: $selectedTab) {
                KeyBindingView()
                    .tabItem {
                        Label("Key Binding", systemImage: "keyboard")
                    }
                    .tag(0)

                UpdaterSettingsView(updater: self.updaterController.updater)
                    .tabItem {
                        Label(
                            "Updater",
                            systemImage: "arrow.triangle.2.circlepath")
                    }
                    .tag(1)

                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
                    .tag(2)
            }
//            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
//                _ in
//                self.accessibilityManager.checkAccessibility()
//            }
            .frame(maxWidth: .infinity, minHeight: 480)
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
            .environmentObject(keyBindingManager)
            .background(
                VisualEffectView(
                    material: NSVisualEffectView.Material.fullScreenUI,
                    blendingMode: NSVisualEffectView.BlendingMode
                        .withinWindow))

        }
        .defaultSize(width: 700, height: 400)

        MenuBarExtra {
            // Status: active/inactive
            Text(
                "Status: \(keyBindingManager.isHandlerEnabledForView ? "Active" : "Inactive")"
            )
            
            Toggle("Enable KeyPhantom", isOn: Binding(
                get: { keyBindingManager.isHandlerEnabledForView },
                set: { $0 ? keyBindingManager.enableHandler() : keyBindingManager.disableHandler() }
            ))
            .keyboardShortcut("k", modifiers: [.command])

            Divider()

            LaunchAtLogin.Toggle()

            CheckForUpdatesView(updater: updaterController.updater)

            Divider()

            // Credit: https://stackoverflow.com/a/77265223
            if #available(macOS 14.0, *) {
                SettingsLink {
                    Text("Settings")
                }
                .keyboardShortcut(",", modifiers: [.command])
            } else {
                Button(
                    action: {
                        if #available(macOS 13.0, *) {
                            NSApp.sendAction(
                                Selector(("showSettingsWindow:")), to: nil,
                                from: nil)
                        } else {
                            NSApp.sendAction(
                                Selector(("showPreferencesWindow:")), to: nil,
                                from: nil)
                        }
                    },
                    label: {
                        Text("Settings")
                    }
                )
                .keyboardShortcut(",", modifiers: [.command])
            }

            // quit
            Button("Quit KeyPhantom") {
                NSApplication.shared.terminate(self)
            }
            .keyboardShortcut("q", modifiers: [.command])

        } label: {
            keyBindingManager.isHandlerEnabledForView
                ? Image(systemName: "keyboard.macwindow")
                : Image("custom.keyboard.macwindow.slash")
        }
        .menuBarExtraStyle(.menu)

    }
}

// Credit: https://stackoverflow.com/a/61458115
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}
