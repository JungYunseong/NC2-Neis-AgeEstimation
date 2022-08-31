//
//  MainView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import Vision
import SwiftUI

struct MainView: View {
    
    @ObservedObject var selectedImage = SelectedImage()
    
    @State var requests = [VNRequest]()
    @State var faceImageArr = [UIImage]()
    @State var selectedFace: UIImage?
    @State var openCamera: Bool = false
    @State var openGallery: Bool = false
    @State var resultAge: String = "0"
    
    var body: some View {
        VStack {
            if faceImageArr.count != 0 {
                ResultView(selectedImage: selectedImage, requests: $requests, faceImageArr: $faceImageArr, selectedFace: $selectedFace, resultAge: $resultAge)
            } else {
                InitialView()
            }
            
            Spacer()
            
            Button(action: {
                self.openCamera = true
            }, label: {
                CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
            })
            .fullScreenCover(isPresented: $openCamera) {
                CaptureView(selectedImage: selectedImage)
                    .onDisappear() {
                        self.analyzeImage()
                    }
            }
            
            Button(action: {
                self.openGallery = true
            }, label: {
                CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
            })
            .sheet(isPresented: $openGallery) {
                ImagePicker(selectedImage: $selectedImage.estimationImage, sourceType: .photoLibrary)
                    .onDisappear() {
                        self.analyzeImage()
                    }
            }
            
            Spacer()
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
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        MainView(selectedImage: self.selectedImage)
        CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
            .previewLayout(.fixed(width: 400, height: 100))
        CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
