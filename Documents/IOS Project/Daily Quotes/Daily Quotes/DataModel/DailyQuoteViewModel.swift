//
//  DailyQuoteViewModel.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-30.
//


import Foundation
import FirebaseFirestore

class DailyQuoteViewModel: ObservableObject {
    @Published var quotes = [DailyQuote]()
    private var db = Firestore.firestore()
    private let defaults = UserDefaults(suiteName: "group.com.georgian.DailyQuotes")

    func fetchQuotes() {
        db.collection("quotes").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.quotes = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: DailyQuote.self)
            }

            // Save quotes to UserDefaults with App Group
            let quotesArray = self.quotes.map { $0.text }
            self.defaults?.set(quotesArray, forKey: "quotes")
        }
    }

    func addQuote(text: String, author: String) {
        let quote = DailyQuote(text: text, author: author)
        do {
            let _ = try db.collection("quotes").addDocument(from: quote)
        } catch {
            print("Error adding quote: \(error)")
        }
    }
    
    func deleteQuote(quote: DailyQuote) {
        guard let id = quote.id else { return }
        
        db.collection("quotes").document(id).delete { error in
            if let error = error {
                print("Error deleting quote: \(error)")
            } else {
                DispatchQueue.main.async {
                    if let index = self.quotes.firstIndex(where: { $0.id == id }) {
                        self.quotes.remove(at: index)
                        
                        // Update UserDefaults
                        let quotesArray = self.quotes.map { $0.text }
                        self.defaults?.set(quotesArray, forKey: "quotes")
                    }
                }
            }
        }
    }
}

