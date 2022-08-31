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
    
    @Binding var requests: [VNRequest]
    @Binding var faceImageArr: [UIImage]
    @Binding var selectedFace: UIImage?
    @Binding var resultAge: String
    
    @State var isAnalyze: Bool = true
    
    var body: some View {
        VStack {
            if isAnalyze {
                LottieView("analyze")
            } else {
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
                    .foregroundColor(Color(hex: 0x888888))
                    .padding()
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                self.isAnalyze = false
            }
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

struct ResultView_Previews: PreviewProvider {
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        ResultView(selectedImage: selectedImage, requests: .constant([VNRequest()]), faceImageArr: .constant([UIImage()]), selectedFace: .constant(UIImage()), resultAge: .constant("0"))
    }
}
