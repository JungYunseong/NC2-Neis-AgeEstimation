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
    
    @State var openGallery: Bool = false
    @State var resultAge: String = "0"
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Color.black
                        .frame(width: 80, height: 80)
                    Color.black
                        .frame(width: 80, height: 80)
                    Color.black
                        .frame(width: 80, height: 80)
                    Color.black
                        .frame(width: 80, height: 80)
                    Color.black
                        .frame(width: 80, height: 80)
                }
            }
            
            Text("나이를 측정할 얼굴을 선택해주세요")
            
            Spacer()
            
            Image(uiImage: selectedImage.estimationImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
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
    }
    
//    private func detectFaces(completion: @escaping [VNFaceObservation]? -> Void) {
//        let image = selectedImage)
//    }
}

struct ResultView_Previews: PreviewProvider {
    
    @ObservedObject static var selectedImage = SelectedImage()
    
    static var previews: some View {
        ResultView(selectedImage: self.selectedImage)
    }
}
