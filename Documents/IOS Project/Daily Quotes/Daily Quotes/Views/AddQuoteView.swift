//
//  AddQuoteView.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//
import SwiftUI

struct AddQuoteView: View {
    @ObservedObject var viewModel: DailyQuoteViewModel
    @Binding var isPresented: Bool
    @State private var quoteText = ""
    @State private var author = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a New Quote")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            TextField("Enter quote", text: $quoteText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Enter author", text: $author)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: addQuote) {
                Text("Add Quote")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Please fill in both fields before adding a quote."), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
    }

    private func addQuote() {
        guard !quoteText.isEmpty, !author.isEmpty else {
            showAlert = true
            return
        }

        viewModel.addQuote(text: quoteText, author: author)
        isPresented = false
    }
}
