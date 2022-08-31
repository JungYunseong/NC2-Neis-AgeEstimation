//
//  ResultView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import Vision
import SwiftUI

struct ResultView: View {
    
    @ObservedObject var cameraViewModel: CameraViewModel
    
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
                //                if faceImageArr.count != 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(faceImageArr, id: \.self) { face in
                            Image(uiImage: face)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .padding([.leading, .bottom])
                                .onTapGesture {
                                    self.selectedFace = face
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        self.performFaceAnalysis(on: face)
                                    }
                                }
                        }
                    }
                }
                .background {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.1))
                        .cornerRadius(17, corners: [.bottomLeft, .bottomRight])
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                        .ignoresSafeArea()
                }
                
                Text("\(faceImageArr.count)명의 얼굴이 인식되었습니다")
                    .foregroundColor(Color(hex: 0x888888))
                    .font(.callout)
                //                }
                
                Spacer()
                
                if selectedFace != nil {
                    Text("측정된 얼굴 나이는?")
                        .foregroundColor(Color(hex: 0x303030))
                        .font(.title)
                        .bold()
                        .padding()
                    Text("\(resultAge)살")
                        .foregroundColor(Color(hex: 0x303030))
                        .font(.title)
                        .bold()
                } else {
                    Text("나이를 측정할 얼굴을 선택해주세요")
                        .foregroundColor(Color(hex: 0x303030))
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
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
    
    @ObservedObject static var cameraViewModel = CameraViewModel()
    
    static var previews: some View {
        ResultView(cameraViewModel: cameraViewModel, requests: .constant([VNRequest()]), faceImageArr: .constant([UIImage()]), selectedFace: .constant(UIImage()), resultAge: .constant("0"))
    }
}
