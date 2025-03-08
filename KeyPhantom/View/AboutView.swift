//
//  AboutView.swift
//  KeyPhantom
//
//  Created by Situ Yongcong on 1/3/2025.
//

import AppKit
import SwiftUI

struct AboutView: View {
    private let copyright =
        "© \(Calendar.current.component(.year, from: Date())) situ2001. Made with ♥"

    var body: some View {
        VStack(spacing: 20) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("KeyPhantom")
                .font(.title2)
                .fontWeight(.bold)

            Text(getAppVersion())
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(copyright)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }

    private func getAppVersion() -> String {
        let bundle = Bundle.main
        let version =
            bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "1.0"
        let build =
            bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            ?? "1"
        return "Version \(version) (\(build))"
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .frame(width: 300, height: 300)
    }
}
