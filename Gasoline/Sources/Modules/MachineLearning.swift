//
//  MachineLearning.swift
//  Gasoline
//
//  Created by Wagner Sales on 06/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import CoreML
import Vision
import UIKit

@available(iOS 12.0, *)
public class Detector {
	
	public static let shared = Detector()
	
	private let model: VNCoreMLModel
	
	public required init() {
		guard let model = try? VNCoreMLModel(for: Bikini().model) else {
			fatalError("NSFW should always be a valid model")
		}
		self.model = model
	}
	
	/// The Result of an NSFW Detection
	///
	/// - error: Detection was not successful
	/// - success: Detection was successful. `nsfwConfidence`: 0.0 for safe content - 1.0 for hardcore porn ;)
	public enum DetectionResult {
		case error(Error)
		case success(confidence: Float)
	}
	
	func check(image: UIImage, completion: @escaping (_ result: DetectionResult) -> Void) {

		var requestHandler: VNImageRequestHandler
		if let cgImage = image.cgImage {
			requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
		} else if let ciImage = image.ciImage {
			requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        } else {
            let error = NSError(domain: "Either cgImage nor ciImage must be set inside of UIImage", code: 0, userInfo: nil)
            let result = DetectionResult.error(error)
            completion(result)
            return
        }
		
		self.check(requestHandler, completion: completion)
	}
}

@available(iOS 12.0, *)
extension Detector {

	func check(_ requestHandler: VNImageRequestHandler, completion: @escaping (_ result: DetectionResult) -> Void) {

        /// The request that handles the detection completion
		let request = VNCoreMLRequest(model: self.model, completionHandler: { (request, error) in
			guard let observations = request.results as? [VNClassificationObservation] else {

                    let error = NSError(domain: "Detection failed: Results not found", code: 0, userInfo: nil)
                    let result = DetectionResult.error(error)
                    completion(result)

                    return
			}

            let observation = observations.first(where: { $0.identifier.lowercased() == "HOT".lowercased() })
			completion(.success(confidence: observation?.confidence ?? 0))
		})
		
		/// Start the actual detection
		do {
			try requestHandler.perform([request])
		} catch {
            let result = DetectionResult.error(error)
            completion(result)
		}
	}
}
