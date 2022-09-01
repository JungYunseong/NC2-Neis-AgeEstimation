//
//  ClassifierModel.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/30.
//

import Vision
import SwiftUI

extension MainView {
    
    var selectedCiImage: CIImage? {
        get {
            CIImage(image: cameraViewModel.estimationImage)
        }
    }
    
    func detectFaces() {
        if let ciImage = self.selectedCiImage {
            let detecFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            do {
                try requestHandler.perform([detecFaceRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        if let faces = request.results as? [VNFaceObservation] {
            DispatchQueue.main.async {
                self.displayUI(for: faces)
            }
        }
    }
    
    func displayUI(for faces: [VNFaceObservation]) {
        
        self.selectedFace = nil
        self.faceImageArr.removeAll()
        
        let context = CIContext()
        let faceImage = cameraViewModel.estimationImage
        
        guard let image = CIImage(image: faceImage),
              let cgimg = context.createCGImage(image, from: image.extent) else { return }
        
        for (_, face) in faces.enumerated() {
            let w = face.boundingBox.size.width * faceImage.size.width
            let h = face.boundingBox.size.height * faceImage.size.height
            let x = face.boundingBox.origin.x * faceImage.size.width
            let y = (1 - face.boundingBox.origin.y) * faceImage.size.height - h
            let cropRect = CGRect(x: x * faceImage.scale, y: y * faceImage.scale, width: w * faceImage.scale, height: h * faceImage.scale)
            
            if let croppedImage = cgimg.cropping(to: cropRect) {
                let croppedUiImage = UIImage(cgImage: croppedImage,
                                             scale: faceImage.scale,
                                             orientation: faceImage.imageOrientation)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.faceImageArr.append(croppedUiImage)
                }
            }
        }
    }
    
    func handleAgeClassification(request: VNRequest, error: Error?) {
        if let ageObservation = request.results?.first as? VNClassificationObservation {
            print("age: \(ageObservation.identifier), confidence: \(ageObservation.confidence)")
            
            self.estimateAge = Int(ageObservation.identifier) ?? 0
        }
    }
    
    func analyzeImage() {
        self.detectFaces()
        
        do {
            let predictionModel = try VNCoreMLModel(for: AgePrediction(configuration: MLModelConfiguration()).model)
            self.requests.append(VNCoreMLRequest(model: predictionModel, completionHandler: handleAgeClassification))
        } catch {
            print(error)
        }
    }
}
