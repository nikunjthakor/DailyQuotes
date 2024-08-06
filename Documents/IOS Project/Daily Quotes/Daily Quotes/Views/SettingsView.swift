//
//  SettingsView.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Button("Open Notification Settings") {
                    openSettings()
                }
            }
        }
    }

    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}
