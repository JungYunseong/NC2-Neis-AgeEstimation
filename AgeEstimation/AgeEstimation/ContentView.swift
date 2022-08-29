//
//  ContentView.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
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
                    .frame(width: .infinity, height: .infinity)
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
    static var previews: some View {
        ContentView()
    }
}
