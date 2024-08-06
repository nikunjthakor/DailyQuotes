//
//  ContentView.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//
import SwiftUI
import UIKit

struct HomeView: View {
  @ObservedObject var viewModel = DailyQuoteViewModel()
  @State private var isSidebarOpen = false
  @State private var backgroundImage: UIImage? = nil

  var body: some View {
    NavigationView {
      ZStack(alignment: .leading) {
        if isSidebarOpen {
          SidebarView()
            .frame(width: 300)
            .background(Color.gray)
            .offset(x: 0)
            .zIndex(1)
            .animation(.easeInOut, value: isSidebarOpen)
        }
              
        VStack {
          if let bgImage = backgroundImage {
            Image(uiImage: bgImage)
              .resizable()
              .scaledToFill()
              .edgesIgnoringSafeArea(.all)
              .overlay(
                Color.black.opacity(0.3)
              )
          }

          Text(viewModel.quotes.randomElement()?.text ?? "No quotes available")
            .font(.title2)
            .padding(100)
            .background(Color.white.opacity(0.7))
            .cornerRadius(8)

          NavigationLink(destination: SetQuoteWallpaperView { image in
            self.backgroundImage = image
          }) {
            Text("Set Quote Wallpaper")
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
          .padding(.top, 20)
           
        }
        .opacity(isSidebarOpen ? 1.5 : 2.0)
        .disabled(isSidebarOpen) // Disable main content when sidebar open
      }
      .zIndex(0)
      .navigationBarItems(leading: Button(action: {
        withAnimation {
          isSidebarOpen.toggle()
        }
      }) {
        Image(systemName: isSidebarOpen ? "xmark" : "line.3.horizontal")
          .font(.title)
      })
      .navigationTitle("Daily Quotes")
    }
    .onAppear {
      viewModel.fetchQuotes()
    }
  }
}


struct SetQuoteWallpaperView: UIViewControllerRepresentable {
    var completion: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: SetQuoteWallpaperView

        init(_ parent: SetQuoteWallpaperView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.completion(image)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct SidebarView: View {
  var body: some View {
    List {
      NavigationLink(destination: FavoriteQuotesView(viewModel: DailyQuoteViewModel())) {
        SidebarCell(title: "Favorite Quotes", icon: "heart")
      }
      NavigationLink(destination: CaptureBackgroundView()) {
        SidebarCell(title: "Gallery", icon: "photo")
      }
      NavigationLink(destination: SettingsView()) {
        SidebarCell(title: "Settings", icon: "gear")
      }
    }
    .listStyle(SidebarListStyle())
  }
}
struct SidebarCell: View {
  let title: String
  let icon: String? // Optional icon name

  var body: some View {
    HStack {
      if let icon = icon {
        Image(systemName: icon)
          .foregroundColor(.blue)
          .padding(.horizontal, 10)
      }
      Text(title)
        .foregroundColor(.blue)
        .font(.system(size: 18))
    }
    .padding(.vertical, 10)
  }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
