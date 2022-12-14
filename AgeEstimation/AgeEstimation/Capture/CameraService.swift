//
//  CameraService.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/29.
//

import Foundation
import AVFoundation

class CameraService {
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    var isFront: Bool = true
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: isFront ? .front : .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
    func changeCameraPosition() {
        self.isFront.toggle()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let session = AVCaptureSession()
            
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.isFront ? .front : .back) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self.output) {
                        session.addOutput(self.output)
                    }
                    self.previewLayer.videoGravity = .resizeAspectFill
                    self.previewLayer.session = session
                    
                    session.startRunning()
                    self.session = session
                } catch {
                    print(error)
                }
            }
        }
    }
}

