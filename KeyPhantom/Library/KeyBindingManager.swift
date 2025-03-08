//
//  KeyBindingManager.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 23/2/2025.
//

import CoreData
import Foundation
import KeyboardShortcuts
import SwiftUI

class KeyBindingManager: ObservableObject {
    @Published var keyBindings: [KeyBinding] = [] {
        didSet {
            print("[KeyBindingManager] keyBindings didSet")
            // TODO: brute-force, should refactor it.
            self.listenOnAllKeyBindingShortcuts()
        }
    }

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.fetchKeyBindings()

        self.listenOnAllKeyBindingShortcuts()

        #if DEBUG
            //            self.keyBindings.append(
            //                KeyBinding(
            //                    valueForEvent: .keyDown(KeyboardKey(keyCode: 0x7C)),
            //                    targetApplication: AppListManager.shared.getURLForTest())
            //            )
        #endif
    }

    // MARK: - CRUD methods

    private func fetchKeyBindings() {
        let request: NSFetchRequest<CoreDataKeyBinding> =
            CoreDataKeyBinding.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \CoreDataKeyBinding.createdAt, ascending: true)
        ]

        do {
            let coreDataKeyBindings = try viewContext.fetch(request)
            keyBindings = try coreDataKeyBindings.map { coreDataKeyBinding in
                try coreDataKeyBinding.toModel()
            }
        } catch {
            // TODO: how to handle this error?
            print("Failed to fetch key bindings: \(error)")
        }
    }

    func addKeyBinding(_ keyBinding: KeyBinding) {
        let _ = CoreDataKeyBinding.fromModel(
            keyBinding, self.viewContext)

        self.saveContext()
        self.fetchKeyBindings()
    }

    func updateKeyBinding(_ keyBinding: KeyBinding) {
        let request: NSFetchRequest<CoreDataKeyBinding> =
            CoreDataKeyBinding.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@", keyBinding.id as CVarArg)
        do {
            let coreDataKeyBindings = try viewContext.fetch(request)
            if let coreDataKeyBinding = coreDataKeyBindings.first {
                // update all properties
                coreDataKeyBinding.targetApplication =
                    keyBinding.targetApplication
                coreDataKeyBinding.valueForEventRef = keyBinding.valueForEvent
                coreDataKeyBinding.enabledBoolRef = keyBinding.enabled

                saveContext()
                fetchKeyBindings()
            }
        } catch {
            print("Failed to update key binding: \(error)")
        }
    }

    func deleteKeyBinding(_ keyBinding: KeyBinding) {
        let request: NSFetchRequest<CoreDataKeyBinding> =
            CoreDataKeyBinding.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@", keyBinding.id as CVarArg)
        do {
            let coreDataKeyBindings = try viewContext.fetch(request)
            if let coreDataKeyBinding = coreDataKeyBindings.first {
                viewContext.delete(coreDataKeyBinding)

                saveContext()
                fetchKeyBindings()
            }
        } catch {
            print("Failed to delete key binding: \(error)")
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    // MARK: - Keyboard shortcuts listener

    @AppStorage("handlerEnabled")
    private var handlerEnabled = true

    var isHandlerEnabledForView: Bool {
        self.handlerEnabled
    }

    public func enableHandler() {
        AccessibilityManager.shared.checkAccessibility()
        if AccessibilityManager.shared.accessibilityEnabled {
            print("Accessibility is enabled")
            handlerEnabled = true
        } else {
            print("Accessibility is disabled. Please enable it.")
            handlerEnabled = false
        }
    }

    public func disableHandler() {
        handlerEnabled = false
    }

    private func listenOnAllKeyBindingShortcuts() {
        // remove
        KeyboardShortcuts.removeAllHandlers()

        keyBindings.forEach { binding in
            KeyboardShortcuts.onKeyDown(for: binding.getKeyBoardShortcutsName())
            {
                [self] in
                if binding.enabled {
                    onShortcutsKeyDown(for: binding)
                }
            }
        }
    }

    private func onShortcutsKeyDown(for keyBinding: KeyBinding) {
        if !handlerEnabled {
            print("Handler is disabled, ignore the event")
            return
        }

        print("Shortcut triggered for keyBinding: \(keyBinding)")

        let sender = KeyboardEventSender.shared

        switch keyBinding.valueForEvent {
        case .keyDown(let targetKey):
            do {
                print(
                    "Sending keyDown event for key: \(targetKey) to application: \(keyBinding.targetApplication)"
                )

                sender.send(key: targetKey, to: keyBinding.targetApplication)
            }
        default:
            do {
                print("TODO")
            }
        }
    }
}
