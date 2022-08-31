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
    
    @ObservedObject var cameraViewModel: CameraViewModel
    
    @State var openGallery = false
    
    var body: some View {
        VStack {
            ZStack {
                cameraViewModel.cameraPreview
                    .cornerRadius(47)
                    .opacity(cameraViewModel.shutterEffect ? 0 : 1)
                    .padding([.horizontal, .bottom], 17)
                    .onAppear {
                        cameraViewModel.configure()
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
                    ImagePicker(selectedImage: $cameraViewModel.estimationImage, sourceType: .photoLibrary)
                }
                .onDisappear() {
                    dismiss()
                }
                
                Spacer()
                
                Button(action: {
                    cameraViewModel.capturePhoto()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                }, label: {
                    CaptureButtonView()
                })
                
                Spacer()
                
                Button(action: {
                    cameraViewModel.changeCamera()
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
    
    @ObservedObject static var cameraViewModel = CameraViewModel()
//    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        CaptureView(cameraViewModel: cameraViewModel)
//        CaptureView(selectedImage: selectedImage)
    }
}
