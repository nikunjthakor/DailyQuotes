//
//  QuoteModel.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-30.
//

import Foundation
import FirebaseFirestore

struct DailyQuote: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var author: String
}
