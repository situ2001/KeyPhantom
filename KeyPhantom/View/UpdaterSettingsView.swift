//
//  UpdaterSettingsView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 2/3/2025.
//

import Sparkle
import SwiftUI

// This is the view for our updater settings
// It manages local state for checking for updates and automatically downloading updates
// Upon user changes to these, the updater's properties are set. These are backed by NSUserDefaults.
// Note the updater properties should *only* be set when the user changes the state.
struct UpdaterSettingsView: View {
    private let updater: SPUUpdater

    @ObservedObject private var checkForUpdatesViewModel:
        CheckForUpdatesViewModel

    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool

    init(updater: SPUUpdater) {
        self.updater = updater

        self.automaticallyChecksForUpdates =
            updater.automaticallyChecksForUpdates
        self.automaticallyDownloadsUpdates =
            updater.automaticallyDownloadsUpdates

        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(
            updater: updater)
    }

    var body: some View {
        VStack {
            Button("Check for Updates…", action: updater.checkForUpdates)
                .disabled(!checkForUpdatesViewModel.canCheckForUpdates)

            Toggle(
                "Automatically check for updates",
                isOn: $automaticallyChecksForUpdates
            )
            .onChange(of: automaticallyChecksForUpdates) { newValue in
                updater.automaticallyChecksForUpdates = newValue
            }

            Toggle(
                "Automatically download updates",
                isOn: $automaticallyDownloadsUpdates
            )
            .disabled(!automaticallyChecksForUpdates)
            .onChange(of: automaticallyDownloadsUpdates) { newValue in
                updater.automaticallyDownloadsUpdates = newValue
            }
        }.padding()
    }
}
