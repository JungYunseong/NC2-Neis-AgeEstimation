//
//  resultView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import SwiftUI

struct resultView: View {
    
    @State var capturedImage: UIImage? = nil
    @State var selectedImage = UIImage()
    @State var openGallery: Bool = false
    @State var resultAge: String = "0"
    
    var body: some View {
        VStack {
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
                CaptureView(capturedImage: $capturedImage)
            }, label: {
                CustomButtonView(title: "카메라로 촬영하기", description: "카메라로 촬영하여 나이를 측정하세요", color: Color.blue)
            })
            
            Button(action: {
                self.openGallery = true
            }, label: {
                CustomButtonView(title: "갤러리에서 가져오기", description: "갤러리의 사진으로 나이를 측정하세요", color: Color.yellow)
            })
            .sheet(isPresented: $openGallery) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
            }
        }
    }
}

struct resultView_Previews: PreviewProvider {
    static var previews: some View {
        resultView()
    }
}
