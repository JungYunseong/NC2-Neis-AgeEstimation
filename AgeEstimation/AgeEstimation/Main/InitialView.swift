//
//  InitialView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/31.
//

import SwiftUI

struct InitialView: View {
    
    @State var isLicenseView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isLicenseView = true
                }, label: {
                    Text("라이선스")
                        .foregroundColor(Color(hex: 0x303030))
                        .font(.body)
                })
                .padding()
                .sheet(isPresented: $isLicenseView) {
                    LicenseView()
                }
            }
            Spacer()
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
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
