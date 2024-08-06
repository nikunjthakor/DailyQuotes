//
//  PersistenceController.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DailyQuotesModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            // Use the shared app group container
            if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourcompany.DailyQuotes") {
                let storeURL = appGroupURL.appendingPathComponent("DailyQuotes.sqlite")
                let description = NSPersistentStoreDescription(url: storeURL)
                container.persistentStoreDescriptions = [description]
            }
        }

        container.loadPersistentStores { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self?.addDefaultQuotesIfNeeded()
        }
    }

    private func addDefaultQuotesIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                // Add default quotes
                let defaultQuotes = [
                    "The best way to predict the future is to invent it.",
                    "Life is 10% what happens to us and 90% how we react to it.",
                    "The only way to do great work is to love what you do.",
                    "Success is not the key to happiness. Happiness is the key to success.",
                    "Your time is limited, don’t waste it living someone else’s life.",
                    "The purpose of our lives is to be happy.",
                    "Get busy living or get busy dying.",
                    "You have within you right now, everything you need to deal with whatever the world can throw at you.",
                    "Believe you can and you're halfway there.",
                    "The only impossible journey is the one you never begin."
                ]

                for text in defaultQuotes {
                    let newQuote = Quote(context: context)
                    newQuote.text = text
                    newQuote.isFavorite = false
                }

                try context.save()
            }
        } catch {
            print("Failed to fetch or save quotes: \(error.localizedDescription)")
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newQuote = Quote(context: viewContext)
            newQuote.text = "Sample Quote"
            newQuote.isFavorite = true
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
