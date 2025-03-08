//
//  SelectedAppView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 2/3/2025.
//

import SwiftUI

struct SelectedAppView: View {
    var appItem: AppItem?
    var onSelected: (AppItem) -> Void

    @State private var isAppListViewPresented = false
    @State private var isHovering = false

    var body: some View {
        HStack {
            if let appItem = appItem {
                Image(
                    nsImage: appItem.icon
                )
                .resizable()
                .frame(width: 24, height: 24)
                Text(appItem.name)
            } else {
                Text("Select an application")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isAppListViewPresented = true
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
        // WHY?
        .contentShape(Rectangle())
        .onHover {
            isHovering = $0
        }
        .onTapGesture {
            isAppListViewPresented = true
        }
        .sheet(isPresented: $isAppListViewPresented) {
            AppListView { appItem in
                self.onSelected(appItem)
            }
        }
    }
}
