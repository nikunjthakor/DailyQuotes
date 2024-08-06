//
//  Daily_QuotesApp.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import SwiftUI
import CoreData
import Firebase

@main
struct Daily_QuotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}


