//
//  KeyBindingCreateView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 2/3/2025.
//

import KeyboardShortcuts
import SwiftUI

struct KeyBindingCreateView: View {
    var onSave: (KeyBinding) -> Void

    @Environment(\.dismiss) private var dismiss

    // keyBinding to be created
    @State private var keyBinding: KeyBinding = KeyBinding.defaultValue()

    // use nil for did not pick any value
    @State private var valueForEvent: ValueForEvent? = nil

    // appItem for keyBinding
    private var appItem: AppItem? {
        AppListManager.shared.getAppItem(from: keyBinding.targetApplication)
    }

    @State private var isAppListViewPresented: Bool = false

    private var canBeSaved: Bool {
        self.valueForEvent != nil
            && self.appItem != nil
    }

    var body: some View {
        VStack(alignment: .center) {
            Form {
                // 1. record shortcuts
                KeyboardShortcuts.Recorder(
                    for: KeyboardShortcuts.Name(
                        keyBinding.shortcutKeyName)
                )
                .padding()
                .frame(width: 200, alignment: .center)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(5)

                HStack {
                    Image(systemName: "arrow.down")
                        .font(.title)
                        .padding(.vertical, 10)
                        .foregroundColor(.gray)

                    Text("will trigger the keycode")
                        .foregroundColor(.gray)
                }

                // 2. record key sent
                KeyCodeView(
                    valueForEvent: self.valueForEvent,
                    showBackground: true,
                    onChange: {
                        self.valueForEvent = ValueForEvent.keyDown(
                            .init(keyCode: $0))
                        self.keyBinding.valueForEvent = self.valueForEvent!
                    }
                )
                .frame(width: 200)

                HStack {
                    Image(systemName: "arrow.down")
                        .font(.title)
                        .padding(.vertical, 10)
                        .foregroundColor(.gray)

                    Text("that will be sent to")
                        .foregroundColor(.gray)
                }

                // 3. pick to Application
                SelectedAppView(
                    appItem: self.appItem,
                    onSelected: { appItem in
                        keyBinding.targetApplication = appItem.url
                        isAppListViewPresented = false
                    }
                )
                .padding()
                .frame(width: 200)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(5)

            }
            .padding()

            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Save") {
                    onSave(keyBinding)
                }
                .buttonStyle(BorderedButtonStyle())
                .keyboardShortcut(.defaultAction)
                .disabled(!canBeSaved)
            }
        }
        .padding()
        .frame(width: 400)
    }
}

#Preview {
    KeyBindingCreateView(
        onSave: { _ in }
    )
    .environment(
        \.managedObjectContext,
        PersistenceController.preview.container.viewContext
    )
}
