//
//  KeyBindingView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 22/2/2025.
//

import SwiftUI

struct KeyBindingView: View {
    @EnvironmentObject private var keyBindingManager: KeyBindingManager

    @State private var isCreating = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Toggle for enabling/disabling all key bindings
                Toggle(
                    "Enable KeyPhantom",
                    isOn: Binding(
                        get: { keyBindingManager.isHandlerEnabledForView },
                        set: {
                            $0
                                ? keyBindingManager.enableHandler()
                                : keyBindingManager.disableHandler()
                        }
                    ))
                .toggleStyle(.switch)

                Spacer()

                Button {
                    isCreating = true
                } label: {
                    Label("Add Key Binding", systemImage: "plus")
                }
                .sheet(isPresented: $isCreating) {
                    KeyBindingCreateView { keyBinding in
                        keyBindingManager.addKeyBinding(keyBinding)
                        isCreating = false
                    }
                }
            }
            .padding(8)

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

                Divider().frame(width: 1)

                Text("Action")
                    .frame(width: 100, alignment: .center)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.15))
            .frame(height: 25)

            HStack(spacing: 0) {
                List {
                    ForEach($keyBindingManager.keyBindings, id: \.id) {
                        keyBinding in
                        KeyBindingRowView(
                            keyBinding: keyBinding,
                            keyBindingManager: keyBindingManager
                        )
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }

    }
}

#Preview {
    KeyBindingView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
        .environmentObject(
            KeyBindingManager(
                context: PersistenceController.preview.container.viewContext))
}
