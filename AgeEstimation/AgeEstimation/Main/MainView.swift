//
//  MainView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import Vision
import SwiftUI

struct MainView: View {
    
    @ObservedObject var cameraViewModel: CameraViewModel
    
    @State private var showToast = false
    @State private var openCamera: Bool = false
    @State private var openGallery: Bool = false
    @State var requests = [VNRequest]()
    @State var faceImageArr = [UIImage]()
    @State var selectedFace: UIImage?
    @State var estimateAge: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                if faceImageArr.count == 0 {
                    InitialView()
                } else {
                    ResultView(cameraViewModel: cameraViewModel,
                               requests: $requests,
                               faceImageArr: $faceImageArr,
                               selectedFace: $selectedFace,
                               estimateAge: $estimateAge)
                }
                
                Spacer()
                
                Button(action: {
                    self.openCamera = true
                    self.faceImageArr.removeAll()
                }, label: {
                    CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
                })
                .fullScreenCover(isPresented: $openCamera) {
                    CaptureView(cameraViewModel: cameraViewModel)
                        .onDisappear() {
                            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                                if faceImageArr.count == 0 {
                                    self.showToast = true
                                }
                                
                                if faceImageArr.count == 1 {
                                    self.selectedFace = faceImageArr.first
                                    self.performFaceAnalysis(on: selectedFace ?? UIImage())
                                }
                            }
                            
                            self.analyzeImage()
                        }
                }
                
                Button(action: {
                    self.openGallery = true
                }, label: {
                    CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
                })
                .sheet(isPresented: $openGallery) {
                    ImagePicker(selectedImage: $cameraViewModel.estimationImage, sourceType: .photoLibrary)
                        .ignoresSafeArea()
                        .onDisappear() {
                            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                                if faceImageArr.count == 0 {
                                    self.showToast = true
                                }
                                
                                if faceImageArr.count == 1 {
                                    self.selectedFace = faceImageArr.first
                                    self.performFaceAnalysis(on: selectedFace ?? UIImage())
                                }
                            }
                            
                            self.analyzeImage()
                        }
                }
                
                Spacer()
            }
            .toast(message: "인식된 얼굴이 없습니다.\n다른 사진을 사용해주세요.",
                   isShowing: $showToast,
                   duration: Toast.long)
        }
    }
    
    func performFaceAnalysis(on image: UIImage) {
        do {
            for request in requests {
                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                try handler.perform([request])
            }
        } catch {
            print(error)
        }
    }
}

struct CustomButtonView: View {
    
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        ZStack {
            RadialGradient(colors: color == Color.blue ? [Color(hex: 0xB2E3FF), Color(hex: 0x00A3FF)] : [Color(hex: 0xFFED90), Color(hex: 0xFFB800)], center: .topLeading, startRadius: 0, endRadius: UIScreen.main.bounds.width / 3)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color.white)
                    Text(description)
                        .foregroundColor(Color.white)
                        .font(.footnote)
                }
                .padding()
                .padding(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
                    .frame(height: 60)
                    .foregroundColor(Color.white)
                    .padding()
                    .padding(.trailing)
            }
        }
        .frame(height: 80)
        .cornerRadius(25)
        .shadow(color: Color(hex: color == Color.blue ? 0x00A3FF : 0xFFB800).opacity(0.15), radius: 20, x: 10, y: 10)
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {

    @ObservedObject static var cameraViewModel = CameraViewModel()

    static var previews: some View {
        MainView(cameraViewModel: cameraViewModel)
        CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
            .previewLayout(.fixed(width: 400, height: 100))
        CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
