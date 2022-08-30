//
//  CaptureView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/29.
//

import SwiftUI

struct CaptureView: View {
    
    let cameraService = CameraService()
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var selectedImage: SelectedImage
    
    @State var capturedImage: UIImage? = nil
    @State var openGallery = false
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                CameraView(cameraService: cameraService) { result in
                    switch result {
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            capturedImage = UIImage(data: data)
                            selectedImage.estimationImage = capturedImage!
                        } else {
                            print("Error: no image data found")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                .padding(.horizontal, 17)
                
                if isLoading {
                    Color.white
                    LottieView("loading")
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    openGallery = true
                }, label: {
                    Image("GalleryIcon")
                })
                .padding(40)
                .sheet(isPresented: $openGallery) {
                    ImagePicker(selectedImage: $selectedImage.estimationImage, sourceType: .photoLibrary)
                }
                
                Spacer()
                
                Button(action: {
                    cameraService.capturePhoto()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                }, label: {
                    CaptureButtonView()
                })
                
                Spacer()
                
                Button(action: {
                    isLoading = true
                    cameraService.changeCameraPosition()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false
                    }
                }, label: {
                    Image("TurnCameraIcon")
                })
                .padding(40)
            }
            .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct CaptureButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: 0xB2E3FF))
                .frame(width: 92, height: 92)
            Circle()
                .fill(Color(hex: 0x00A3FF))
                .frame(width: 48, height: 48)
            
            Image("CameraIcon")
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        CaptureView(selectedImage: selectedImage)
    }
}
