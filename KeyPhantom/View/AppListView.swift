//
//  AppListView.swift
//  KeyPhantom
//
//  Created by situ on 20/2/2025.
//

import SwiftUI

struct AppListView: View {
    @StateObject var appListManager: AppListManager = AppListManager.shared

    // fn for view dimiss
    @Environment(\.dismiss) var dismiss

    // on appSelected callback function
    var onAppSelected: ((AppItem) -> Void)?

    @State var selectedRow: AppItem?

    @State var searchText = ""

    private var filteredAppList: [AppItem] {
        if searchText.isEmpty {
            return appListManager.appList
        } else {
            return appListManager.appList.filter { app in
                app.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // TODO: should locate to the selected row when appear?
    var body: some View {
        VStack {
            // Search bar
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(selection: $selectedRow) {
                ForEach(filteredAppList, id: \.name) { app in
                    HStack {
                        Image(
                            nsImage: app.icon
                        )
                        .resizable()
                        .frame(width: 32, height: 32)
                        Text(app.name)
                    }
                    .tag(app)
                    // double click to select
                    // TODO: how to expand the double-clickable area to the whole row?
                    .onTapGesture(count: 2) {
                        selectedRow = app
                        onAppSelected?(app)
                        dismiss()
                    }
                }
            }
            .onAppear {
                appListManager.updateAppList()
            }
            // FIXME: if i use this api, system will stuck
            // macOS 15.3
            // with error, for example: Detected potentially harmful notification post rate of 281.216 notifications per second
            //            .searchable(text: $searchText)

            // add cancel or done button
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Button("Select") {
                    onAppSelected?(selectedRow!)
                    dismiss()
                }
                .disabled(selectedRow == nil)
                .buttonStyle(BorderedButtonStyle())
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 300, height: 400)
    }

}

#Preview {
    AppListView()
}
