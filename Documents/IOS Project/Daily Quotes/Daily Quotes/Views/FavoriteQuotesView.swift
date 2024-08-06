//
//  FavoriteQuotesView.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import SwiftUI

struct FavoriteQuotesView: View {
    @ObservedObject var viewModel: DailyQuoteViewModel
    @State private var showingAddQuoteView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Favorite Quotes")
                    .font(.largeTitle)
                    .padding()

                List {
                    ForEach(viewModel.quotes) { quote in
                        VStack(alignment: .leading) {
                            Text(quote.text)
                            Text("- \(quote.author)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteQuote)
                }

                Button(action: {
                    showingAddQuoteView = true
                }) {
                    Text("Add Quote")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                .sheet(isPresented: $showingAddQuoteView) {
                    AddQuoteView(viewModel: viewModel, isPresented: $showingAddQuoteView)
                }
            }
            .onAppear {
                viewModel.fetchQuotes()
            }
        }
    }

    private func deleteQuote(at offsets: IndexSet) {
        offsets.forEach { index in
            let quote = viewModel.quotes[index]
            viewModel.deleteQuote(quote: quote)
        }
    }
}
