//
//  CaptureView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/29.
//

import SwiftUI
import AVFoundation

struct CaptureView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = CameraViewModel()
    @ObservedObject var selectedImage: SelectedImage
    
    @State var capturedImage: UIImage? = nil
    @State var openGallery = false
    
    var body: some View {
        VStack {
            ZStack {
                viewModel.cameraPreview
                    .cornerRadius(47)
                    .opacity(viewModel.shutterEffect ? 0 : 1)
                    .padding([.horizontal, .bottom], 17)
                    .onAppear {
                        viewModel.configure()
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
                .onDisappear() {
                    if self.selectedImage != nil {
                        dismiss()
                    }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.capturePhoto()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedImage.estimationImage = viewModel.capturedImage ?? UIImage()
                        dismiss()
                    }
                }, label: {
                    CaptureButtonView()
                })
                
                Spacer()
                
                Button(action: {
                    viewModel.changeCamera()
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
