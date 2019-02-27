//
//  ImageDecoder.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 2/27/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit

enum ContentMode {
    case aspectFill
    case aspectFit
}

class ImageDecoder {

    let queue = OperationQueue()
    static let imageSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

    init() {
		let label = "br.com.wagnersales.imageDecoder"
        let underlyingQueue = DispatchQueue(label: label, attributes: DispatchQueue.Attributes.concurrent)
        queue.underlyingQueue = underlyingQueue
        queue.maxConcurrentOperationCount = 4
    }

    func decode(_ image: UIImage, targetSize: CGSize = imageSize, contentMode: ContentMode = .aspectFill) -> UIImage {
        let size = decodedSize(image.cgImage,
                               targetSize: targetSize,
                               contentMode: contentMode)
		let cgContext = CGContext(data: nil,
		                          width: Int(size.width),
		                          height: Int(size.height),
		                          bitsPerComponent: 8,
		                          bytesPerRow: 0,
		                          space: CGColorSpaceCreateDeviceRGB(),
		                          bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard
			let context = cgContext,
			let cgImage = image.cgImage else {
				return image
		}
        context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        guard let decodedImage = context.makeImage() else { return image }
        return UIImage(cgImage: decodedImage, scale: image.scale, orientation: image.imageOrientation)
    }

    func decodedSize(_ image: CGImage?, targetSize: CGSize, contentMode: ContentMode) -> CGSize {
        let imageSize = CGSize(width: (image?.width)!, height: (image?.height)!)
        let horizontalScale = targetSize.width / imageSize.width
        let verticalScale = targetSize.height / imageSize.height
		let scaleMax = max(horizontalScale, verticalScale)
		let scaleMin = min(horizontalScale, verticalScale)
        let scale = contentMode == .aspectFill ? scaleMax : scaleMin
        let clampedScale: CGFloat = min(scale, 1)
        return CGSize(width: round(clampedScale * imageSize.width), height: round(clampedScale * imageSize.height))
    }
}
