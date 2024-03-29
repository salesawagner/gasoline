//
//  UIImage+Coreml.swift
//  Gasoline
//
//  Created by Wagner Sales on 07/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

extension UIImage {
	func buffer() -> CVPixelBuffer? {
		var pixelBuffer: CVPixelBuffer? = nil
		let width = 224
		let height = 224
		let attrs = [kCVPixelBufferCGImageCompatibilityKey:
			kCFBooleanTrue,
					 kCVPixelBufferCGBitmapContextCompatibilityKey:
			kCFBooleanTrue] as CFDictionary
		
		CVPixelBufferCreate(kCFAllocatorDefault, width, height,
							kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
		CVPixelBufferLockBaseAddress(pixelBuffer!,
									 CVPixelBufferLockFlags(rawValue:0))
		let colorspace = CGColorSpaceCreateDeviceRGB()
		let bitmapContext = CGContext(data:
			CVPixelBufferGetBaseAddress(pixelBuffer!),
									  width: width,
									  height: height,
									  bitsPerComponent: 8,
									  bytesPerRow:
			CVPixelBufferGetBytesPerRow(pixelBuffer!),
									  space: colorspace,
									  bitmapInfo:
			CGImageAlphaInfo.noneSkipFirst.rawValue)!
		bitmapContext.draw(self.cgImage!, in:
			CGRect(x: 0, y: 0, width: width, height: height))
		return pixelBuffer
	}
}
