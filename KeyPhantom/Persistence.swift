//
//  Persistence.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 20/2/2025.
//

import CoreData
import Carbon.HIToolbox

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //        for _ in 0..<10 {
        //            let newItem = Item(context: viewContext)
        //            newItem.timestamp = Date()
        //        }

        // Add two test data
        let keyBinding1 = KeyBinding(
            id: UUID(), shortcutKeyName: "testKeyBinding1",
            valueForEvent: .keyDown(.init(keyCode: kVK_LeftArrow)),
            targetApplication: AppListManager.shared.getURLForTest(),
            enabled: true
        )
        let keyBinding2 = KeyBinding(
            id: UUID(), shortcutKeyName: "testKeyBinding2",
            valueForEvent: .keyDown(.init(keyCode: kVK_RightArrow)),
            targetApplication: AppListManager.shared.getURLForTest(),
            enabled: true
        )
        
        let _ = CoreDataKeyBinding.fromModel(keyBinding1, viewContext)
        let _ = CoreDataKeyBinding.fromModel(keyBinding2, viewContext)

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "KeyPhantom")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(
                fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
