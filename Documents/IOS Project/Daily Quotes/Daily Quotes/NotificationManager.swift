//
//  NotificationManager.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import FirebaseFirestore
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private var db = Firestore.firestore()

    func scheduleNotifications() {
        requestAuthorization()
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleNotification()
            } else {
                if let error = error {
                    print("Notification permission denied: \(error.localizedDescription)")
                }
            }
        }
    }

    private func scheduleNotification() {
        // Fetch a random quote from Firestore
        fetchRandomQuote { quote in
            guard let quote = quote else {
                print("No quotes available")
                return
            }

            // Configure the notification content
            let content = UNMutableNotificationContent()
            content.title = "Daily Quote"
            content.body = quote.text
            content.sound = .default

            // Set trigger for 6 AM every day
            var dateComponents = DateComponents()
            dateComponents.hour = 6
            dateComponents.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // Add the notification request
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to add notification request: \(error.localizedDescription)")
                }
            }
        }
    }

    private func fetchRandomQuote(completion: @escaping (DailyQuote?) -> Void) {
        db.collection("quotes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch quotes from Firestore: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No quotes found in Firestore")
                completion(nil)
                return
            }

            let quotes = documents.compactMap { try? $0.data(as: DailyQuote.self) }
            let randomQuote = quotes.randomElement()
            completion(randomQuote)
        }
    }
}

