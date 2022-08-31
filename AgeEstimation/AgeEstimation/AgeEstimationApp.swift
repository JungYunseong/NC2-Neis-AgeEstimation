//
//  AgeEstimationApp.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import SwiftUI

@main
struct AgeEstimationApp: App {
    
    @ObservedObject var selectedImage = SelectedImage()
    
    var body: some Scene {
        WindowGroup {
            MainView(selectedImage: self.selectedImage)
        }
    }
}
