//
//  DecodeOperation.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 2/27/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit

class DecodeOperation: Operation {

    let image: UIImage
    let decoder: ImageDecoder
    let completion: ((UIImage) -> Void)

    init(image: UIImage, decoder: ImageDecoder, completion: @escaping ((UIImage) -> Void)) {
        self.image = image
        self.decoder = decoder
        self.completion = completion
    }

    override func main() {
        if isCancelled {
            return
        }

        let decodedImage = decoder.decode(image)

        if isCancelled {
            return
        }

        OperationQueue.main.addOperation {
            self.completion(decodedImage)
        }
    }

}
