//
//  PhotoPicker.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/09/01.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selectedImage: UIImage
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let photoPicker = UIImagePickerController()
        photoPicker.allowsEditing = false
        photoPicker.sourceType = sourceType
        photoPicker.allowsEditing = true
        photoPicker.delegate = context.coordinator
        
        return photoPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
