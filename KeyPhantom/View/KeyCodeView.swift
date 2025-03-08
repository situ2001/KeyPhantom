//
//  KeyCodeView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 2/3/2025.
//

import SwiftUI

// TODO: refactor it to extensible(e.g compatible for more event types)
struct KeyCodeView: View {
    var valueForEvent: ValueForEvent? = nil
    var showBackground: Bool = false

    @State private var isEditing = false
    @State private var showPopover = false
    @State private var newKeyCode: Int?

    @State private var isHovering = false

    @State private var eventMonitor: Any?

    var onChange: (Int) -> Void

    var body: some View {
        HStack {
            if valueForEvent == nil {
                Text("Click to record")
            } else {
                switch self.valueForEvent {
                case .keyDown(let k):
                    Text(k.description)
                default:
                    Text("Unknown")
                }
            }

            Spacer()

            if isHovering {
                Image(
                    systemName: "pencil.circle.fill"
                )
                .foregroundStyle(.blue)

            }
        }
        .padding()
        .background(
            isEditing
                ? Color.yellow.opacity(0.2)
                : (showBackground ? Color.gray.opacity(0.15) : Color.clear)
        )
        .cornerRadius(5)
        .onHover { hovering in
            isHovering = hovering
        }
        // WHY?
        .contentShape(Rectangle())
        .onTapGesture {
            showPopover = true
        }
        .popover(
            isPresented: $showPopover,
            arrowEdge: .top
        ) {
            VStack {
                Text("Press a key")
                    .onAppear {
                        self.eventMonitor = NSEvent.addLocalMonitorForEvents(
                            matching: .keyDown
                        ) { event in
                            // TODO: preserve the modifier flags
                            // let isShiftPressed = event.modifierFlags.contains(.shift)

                            newKeyCode = Int(event.keyCode)

                            self.onChange(newKeyCode!)
                            showPopover = false
                            return event
                        }
                    }
                    .onDisappear {
                        if let eventMonitor = self.eventMonitor {
                            NSEvent.removeMonitor(eventMonitor)
                            self.eventMonitor = nil
                        }
                    }
            }
            .padding()
        }
    }
}
