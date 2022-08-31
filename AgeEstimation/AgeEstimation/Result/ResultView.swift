//
//  ResultView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import Vision
import SwiftUI

struct ResultView: View {
    
    @ObservedObject var selectedImage: SelectedImage
    
    @State var requests = [VNRequest]()
    @State var faceImageArr = [UIImage]()
    @State var openGallery: Bool = false
    @State var selectedFace: UIImage?
    @State var resultAge: String = "0"
    @State var classificationLabel = "0"
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(faceImageArr, id: \.self) { face in
                        Image(uiImage: face)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                self.selectedFace = face
                                self.performFaceAnalysis(on: face)
                            }
                    }
                }
            }
            
            Text("나이를 측정할 얼굴을 선택해주세요")
            
            Spacer()
            
            Text("측정된 얼굴 나이는?")
                .foregroundColor(Color(hex: 0x303030))
                .font(.title)
                .bold()
                .padding()
            Text("\(resultAge)살")
                .foregroundColor(Color(hex: 0x303030))
                .font(.title)
                .bold()
            
            Spacer()
            
            Text("다른 사진으로 측정하기")
                .foregroundColor(Color(hex: 0x303030))
                .padding()
            
            NavigationLink(destination: {
                CaptureView(selectedImage: selectedImage)
            }, label: {
                CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
            })
            
            Button(action: {
                self.openGallery = true
            }, label: {
                CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
            })
            .sheet(isPresented: $openGallery) {
                ImagePicker(selectedImage: $selectedImage.estimationImage, sourceType: .photoLibrary)
                    .onDisappear() {
                        self.detectFaces { (results) in
                            if let results = results {
                                self.classificationLabel = "\(results.count)"
                            }
                        }
                    }
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            self.detectFaces { (results) in
                if let results = results {
                    self.classificationLabel = "\(results.count)"
                }
            }
            
            do {
                let ageModel = try VNCoreMLModel(for: AgePrediction().model)
                self.requests.append(VNCoreMLRequest(model: ageModel, completionHandler: handleAgeClassification))
            } catch {
                print(error)
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        ResultView(selectedImage: self.selectedImage)
    }
}
