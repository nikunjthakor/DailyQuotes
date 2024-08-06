//
//  AppDelegate.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import UIKit
import UserNotifications


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }

        // Set UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self

        // Schedule initial notifications
        NotificationManager.shared.scheduleNotifications()

        return true
    }

    // This method will be called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Show the notification as a banner and play the sound even when the app is in the foreground
    }
}

