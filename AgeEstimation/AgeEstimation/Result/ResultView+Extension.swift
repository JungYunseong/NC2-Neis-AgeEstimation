//
//  ResultView+Extension.swift
//  AgeEstimation
//
//  Created by Jung Yunseong on 2022/08/31.
//

import Vision
import SwiftUI

extension ResultView {
    
    func detectFaces(completion: @escaping ([VNFaceObservation]?) -> Void) {
        let image = selectedImage.estimationImage
        
        guard let cgImage = image.cgImage else {
            return completion(nil)
        }
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global().async {
            try? handler.perform([detectFaceRequest])
            
            guard let observations = detectFaceRequest.results else {
                return completion(nil)
            }
            return completion(observations)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        if let faces = request.results as? [VNFaceObservation] {
            self.displayUI(for: faces)
        }
    }
    
    func displayUI(for faces: [VNFaceObservation]) {
        
        let faceImage = selectedImage.estimationImage
        
        for (_, face) in faces.enumerated() {
            let w = face.boundingBox.size.width * faceImage.size.width
            let h = face.boundingBox.size.height * faceImage.size.height
            let x = face.boundingBox.origin.x * faceImage.size.width
            let y = (1 - face.boundingBox.origin.y) * faceImage.size.height - h
            let cropRect = CGRect(x: x * faceImage.scale, y: y * faceImage.scale, width: w * faceImage.scale, height: h * faceImage.scale)
            
            if let faceCGImage = faceImage.cgImage?.cropping(to: cropRect) {
                let faceUiImage = UIImage(cgImage: faceCGImage, scale: faceImage.scale, orientation: .up)
                
                self.faceImageArr.removeAll()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.faceImageArr.append(faceUiImage)
                }
            }
        }
    }
}
