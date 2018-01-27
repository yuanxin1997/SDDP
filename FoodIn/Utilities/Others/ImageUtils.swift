//
//  ImageUtils.swift
//  FoodIn
//
//  Created by ryan on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import UIKit

class ImageUtils {
    static func base64EncodeImage(_ image: UIImage) -> String {
        guard var imagedata = UIImagePNGRepresentation(image) else { return "" }
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    static func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

