//
//  AppListManager.swift
//  KeyPhantom
//
//  Created by situ on 20/2/2025.
//

import AppKit
import Foundation

struct AppItem: Identifiable, Hashable {
    var id = UUID()

    var url: URL

    var name: String
    var bundleIdentifier: String

    // TODO: can it be lazily init?
    var icon: NSImage

    init(
        url: URL, name: String, bundleIdentifier: String,
        icon: NSImage
    ) {
        self.url = url
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.icon = icon
    }
}

class AppListManager: ObservableObject {
    /// Singleton instance of the AppListManager.
    static let shared = AppListManager()

    /// Allowed path
    private let allowedPaths = [
        "/Applications",
        "/System/Applications",
    ]

    // array of app names and their corresponding icons
    @Published var appList: [AppItem] = []

    // update appList
    func updateAppList() {
        self.appList = getAllAppItems()
    }

    private init() {
        self.updateAppList()
    }

    /// Returns whether the app with the given name is currently running.
    func isAppRunning(appName: String) -> Bool {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications
        return runningApps.contains { $0.localizedName == appName }
    }

    /// Returns all app bundle URLs (.app directories) found in the given directory.
    private func getApplications(in directory: String) -> [URL] {
        var appURLs: [URL] = []
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: directory, isDirectory: true)

        if let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])
        {
            for case let fileURL as URL in enumerator {
                // Check if the URL represents an app bundle.
                if fileURL.pathExtension == "app" {
                    appURLs.append(fileURL)
                    // Skip further enumeration inside the app bundle.
                    enumerator.skipDescendants()
                }
            }
        }
        return appURLs
    }

    private func isUrlStartingWithAllowedPaths(url: URL) -> Bool {
        return self.allowedPaths.contains { url.path.starts(with: $0) }
    }

    /// Prints the app’s name, bundle identifier, and icon size.
    func getAppItem(from appURL: URL) -> AppItem? {
        if !isUrlStartingWithAllowedPaths(url: appURL) {
            return nil
        }

        guard let bundle = Bundle(url: appURL) else {
            return nil
        }

        let appName = appURL.deletingPathExtension().lastPathComponent
        let bundleIdentifier = bundle.bundleIdentifier ?? "Unknown"

        // Get the app icon using NSWorkspace.
        let icon = NSWorkspace.shared.icon(forFile: appURL.path)

        //        #if DEBUG
        //            print("App Name: \(appName)")
        //            print("Bundle Identifier: \(bundleIdentifier)")
        //            print(
        //                "Icon: \(icon)"
        //            )
        //            print(String(repeating: "-", count: 40))
        //        #endif

        return AppItem(
            url: appURL, name: appName, bundleIdentifier: bundleIdentifier,
            icon: icon)
    }

    func getAllAppItems() -> [AppItem] {
        let appURLs = self.allowedPaths.flatMap { getApplications(in: $0) }
        return appURLs.compactMap { getAppItem(from: $0) }
    }

    func getURLForTest() -> URL {
        URL.init(
            string:
                "file:///Applications/%E5%BE%AE%E4%BF%A1%E8%AF%BB%E4%B9%A6.app/"
        )!
    }
}
