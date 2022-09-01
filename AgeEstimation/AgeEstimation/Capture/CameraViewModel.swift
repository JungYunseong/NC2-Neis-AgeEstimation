//
//  CameraViewModel.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    
    let cameraPreview: AnyView
    
    @Published var shutterEffect = false
    @Published var estimationImage = UIImage()
    
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    // 사진 촬영
    func capturePhoto() {
        if isCameraBusy == false {
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            model.capturePhoto()
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        model.changeCamera()
    }
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
        model.$estimationImage.sink { [weak self] (photo) in
            //            guard let pic = photo else { return }
            self?.estimationImage = photo
        }
        .store(in: &self.subscriptions)
        
        model.$isCameraBusy.sink { [weak self] (result) in
            self?.isCameraBusy = result
        }
        .store(in: &self.subscriptions)
    }
}

