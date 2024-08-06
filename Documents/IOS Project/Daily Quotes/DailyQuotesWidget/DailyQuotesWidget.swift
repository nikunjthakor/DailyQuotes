//
//  DailyQuotesWidget.swift
//  DailyQuotesWidget
//
//  Created by Nikunj Thakor on 2024-07-29.
//
import WidgetKit
import SwiftUI

struct DailyQuotesWidget: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Placeholder quote")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), quote: "Snapshot quote")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.com.georgian.DailyQuotes")
        let quotes = defaults?.stringArray(forKey: "quotes") ?? ["No quote available"]
        
        var entries: [SimpleEntry] = []

        for secondOffset in stride(from: 0, to: 60 * 60 , by: 5 * 60) { // Every 5 minutes
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: Date())!
            let quote = quotes.randomElement() ?? "No quote available"
            let entry = SimpleEntry(date: entryDate, quote: quote)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct DailyQuoteWidgetEntryView: View {
    var entry: DailyQuotesWidget.Entry

    var body: some View {
        Text(entry.quote)
            .padding()
    }
}

@main
struct DailyQuoteWidget: Widget {
    let kind: String = "DailyQuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyQuotesWidget()) { entry in
            DailyQuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Quote")
        .description("Displays a quote every 5 hours.")
    }
}
