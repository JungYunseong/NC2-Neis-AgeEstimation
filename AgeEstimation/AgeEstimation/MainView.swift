//
//  MainView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import SwiftUI

struct MainView: View {
    
    let blueGradientColor: [Color] = [Color(hex: 0xB2E3FF), Color(hex: 0x00A3FF)]
    let yellowGradientColor: [Color] = [Color(hex: 0xFFED90), Color(hex: 0xFFB800)]
    
    @ObservedObject var selectedImage = SelectedImage()
    
    @State var openGallery: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                LottieView("faceScan")
                    .frame(height: UIScreen.main.bounds.height / 3)
                
                Spacer()
                
                Text("얼굴 나이 분석 테스트")
                    .foregroundColor(Color(hex: 0x303030))
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("AI를 이용해 현재 얼굴 나이를 측정해보세요.\n아래 버튼을 사용하여 측정해보세요.")
                    .foregroundColor(Color(hex: 0x303030))
                    .multilineTextAlignment(.center)
                    .padding([.horizontal, .bottom])
                
                Spacer()
                
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
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
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
        .padding([.horizontal, .bottom])
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
