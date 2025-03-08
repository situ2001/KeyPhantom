//
//  KeyBinding.swift
//  KeyPhantom
//
//  Created by situ on 20/2/2025.
//

import AppKit
import CoreData
import Foundation
import KeyboardShortcuts

enum ValueForEvent: Codable {
    case keyDown(KeyboardKey)

    // TODO: leave it Int now.
    case scrollWheel(Int)

    // TODO: leave it Int now.
    case mouseClick(Int)
}

/// The core model of the app, representing a key binding.
/// Relationship: User trigger a `shortcutKeyName` to trigger a `targetKey` for a `targetApplication`.
/// We call the `targetKey` the Phantom Key.
struct KeyBinding: Codable, Identifiable {
    var id: UUID = UUID()

    var enabled: Bool

    /// Store the name of the shortcut
    var shortcutKeyName: String

    /// Store the key code of the target key
    var valueForEvent: ValueForEvent

    /// Store the target application, to which the key binding is triggered.
    /// This url will be read by `AppListManager`
    var targetApplication: URL

    /// Initialize a new key binding from Core Data Model.
    init(
        valueForEvent: ValueForEvent,
        targetApplication: URL,
        enabled: Bool
    ) {
        self.shortcutKeyName = self.id.uuidString
        self.valueForEvent = valueForEvent
        self.targetApplication = targetApplication
        self.enabled = enabled
    }

    init(
        id: UUID,
        shortcutKeyName: String,
        valueForEvent: ValueForEvent,
        targetApplication: URL,
        enabled: Bool
    ) {
        self.id = id
        self.shortcutKeyName = shortcutKeyName
        self.valueForEvent = valueForEvent
        self.targetApplication = targetApplication
        self.enabled = enabled
    }

    func getKeyBoardShortcutsName() -> KeyboardShortcuts.Name {
        return KeyboardShortcuts.Name(self.shortcutKeyName)
    }

    static func defaultValue() -> KeyBinding {
        return KeyBinding(
            valueForEvent: .keyDown(KeyboardKey(keyCode: 0)),
            targetApplication: URL(
                fileURLWithPath: ""),
            enabled: true
        )
    }
}

struct KeyboardKey: Codable {
    /// The key code of the keyboard key.
    var keyCode: Int

    // TODO: preserve the modifier flags
    /// The modifier flags of the keyboard key.
    var modifierFlags: NSEvent.ModifierFlags = []

    var character: String {
        return String(UnicodeScalar(keyCode)!)
    }

    init(keyCode: Int) {
        self.keyCode = keyCode
    }

    init(keyCode: Int, modifierFlags: NSEvent.ModifierFlags) {
        self.keyCode = keyCode
        self.modifierFlags = modifierFlags
    }
}

extension NSEvent.ModifierFlags: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(UInt.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension KeyboardKey {
    enum CodingKeys: String, CodingKey {
        case keyCode
        case modifierFlags
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.keyCode = try container.decode(Int.self, forKey: .keyCode)

        // migiate from old version
        self.modifierFlags =
            try container.decodeIfPresent(
                NSEvent.ModifierFlags.self, forKey: .modifierFlags) ?? []
    }
}

// MARK: - CoreData Model for KeyBinding

extension CoreDataKeyBinding {
    var valueForEventRef: ValueForEvent {
        get {
            do {
                return try JSONDecoder().decode(
                    ValueForEvent.self, from: valueForEventData!)
            } catch {
                print("Error decoding ValueForEvent: \(error)")

                // Return a default value
                return .keyDown(KeyboardKey(keyCode: 0))
            }
        }
        set {
            do {
                valueForEventData = try JSONEncoder().encode(newValue)
            } catch {
                print("Error encoding ValueForEvent: \(error)")
            }
        }
    }

    var enabledBoolRef: Bool {
        get {
            if self.enabled == nil || self.enabled == 1 {
                return true
            } else if self.enabled == 0 {
                return false
            } else {
                fatalError("Invalid value for enabled: \(self.enabled!)")
            }
        }
        set {
            enabled = newValue ? 1 : 0
        }
    }

    static func fromModel(
        _ keyBinding: KeyBinding, _ context: NSManagedObjectContext
    ) -> CoreDataKeyBinding {
        let obj = CoreDataKeyBinding(context: context)
        obj.id = keyBinding.id
        obj.shortcutKeyName = keyBinding.shortcutKeyName
        obj.valueForEventRef = keyBinding.valueForEvent
        obj.targetApplication = keyBinding.targetApplication
        obj.enabled = keyBinding.enabled ? 1 : 0

        return obj
    }

    func toModel() throws -> KeyBinding {
        return KeyBinding(
            id: id!,
            shortcutKeyName: shortcutKeyName!,
            valueForEvent: valueForEventRef,
            targetApplication: targetApplication!,
            enabled: enabledBoolRef
        )
    }

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = Date()
    }
}
