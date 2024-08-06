//
//  CaptureBackgroundView.swift
//  Daily Quotes
//
//  Created by Nikunj Thakor on 2024-07-29.
//

import SwiftUI

struct CaptureBackgroundView: View {
    @State private var isImagePickerPresented = false
    @State private var capturedImage: UIImage? = nil

    var body: some View {
        VStack {
            Text("Capture Background")
                .font(.largeTitle)
                .padding()
            
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Camera interface here")
            }
            
            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("Capture")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $capturedImage)
            }
            
            HStack {
                NavigationLink(destination: HomeView()) {
                    Text("Home")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing, 20)
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 20)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
