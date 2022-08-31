//
//  AgeEstimationApp.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/28.
//

import SwiftUI

@main
struct AgeEstimationApp: App {
    
    @ObservedObject var cameraViewModel = CameraViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(cameraViewModel: cameraViewModel)
        }
    }
}
