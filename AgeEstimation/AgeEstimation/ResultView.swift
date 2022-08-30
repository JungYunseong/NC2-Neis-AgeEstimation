//
//  ResultView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import Vision
import SwiftUI
import UIKit

struct ResultView: View {
    
    @ObservedObject var selectedImage: SelectedImage
    
    @State var faceImageArr = [UIImage]()
    @State var openGallery: Bool = false
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
                    }
                }
            }
            
            Text("나이를 측정할 얼굴을 선택해주세요")
            
            Spacer()
            
            Image(uiImage: selectedImage.estimationImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(self.classificationLabel)
            
            //            Text("측정된 얼굴 나이는?")
            //                .foregroundColor(Color(hex: 0x303030))
            //                .font(.title)
            //                .bold()
            //                .padding()
            //            Text("\(resultAge)살")
            //                .foregroundColor(Color(hex: 0x303030))
            //                .font(.title)
            //                .bold()
            
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
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            self.detectFaces { (results) in
                if let results = results {
                    self.classificationLabel = "\(results.count)"
                }
            }
        }
    }
    
    private func detectFaces(completion: @escaping ([VNFaceObservation]?) -> Void) {
        let image = selectedImage.estimationImage
        
        guard let cgImage = image.cgImage else {
            return completion(nil)
        }
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global().async {
            try? handler.perform([detectFaceRequest])
            
            guard let observations = detectFaceRequest.results else {
                return completion(nil)
            }
            return completion(observations)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        if let faces = request.results as? [VNFaceObservation] {
            self.displayUI(for: faces)
        }
    }
    
    func displayUI(for faces: [VNFaceObservation]) {
        
        let faceImage = selectedImage.estimationImage
        
        for (_, face) in faces.enumerated() {
            let w = face.boundingBox.size.width * faceImage.size.width
            let h = face.boundingBox.size.height * faceImage.size.height
            let x = face.boundingBox.origin.x * faceImage.size.width
            let y = (1 - face.boundingBox.origin.y) * faceImage.size.height - h
            let cropRect = CGRect(x: x * faceImage.scale, y: y * faceImage.scale, width: w * faceImage.scale, height: h * faceImage.scale)
            
            if let faceCGImage = faceImage.cgImage?.cropping(to: cropRect) {
                let faceUiImage = UIImage(cgImage: faceCGImage, scale: faceImage.scale, orientation: .up)
                
                self.faceImageArr.append(faceUiImage)
            }
        }
        
        print(faceImageArr.indices)
    }
}

struct ResultView_Previews: PreviewProvider {
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        ResultView(selectedImage: self.selectedImage)
    }
}
