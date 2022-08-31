//
//  CountingNumberAnimationModifier.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/09/01.
//

import SwiftUI

struct CountingNumberAnimationModifier: AnimatableModifier {
    
    var number: CGFloat = 0
    
    var animatableData: CGFloat {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(NumberLabelView(number: number))
    }
    
    struct NumberLabelView: View {
        let number: CGFloat
        
        var body: some View {
            Text("\(Int(number))살")
                .foregroundColor(Color(hex: 0x303030))
                .font(.title)
                .bold()
        }
    }
}
