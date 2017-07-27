//
//  CropImage.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/1/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

extension UIImage {
    
    func crop(to: CGSize) -> UIImage {
        var to = to
        
        if self.imageOrientation.rawValue == 0 || self.imageOrientation.rawValue == 1 {
            let t = to.width
            to.width = to.height
            to.height = t
        }
        
        var posX : CGFloat = 0.0
        var posY : CGFloat = 0.0
        let cropAspect : CGFloat = to.width / to.height
        
        var cropWidth : CGFloat = to.width
        var cropHeight : CGFloat = to.height
        
        if to.width > to.height { // landscape
            cropWidth = self.size.width
            cropHeight = self.size.width / cropAspect
            posY = (self.size.height - cropHeight) / 2
        } else {
            cropWidth = self.size.height * cropAspect
            cropHeight = self.size.height
            posX = (self.size.width - cropWidth) / 2
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cropWidth, cropHeight)
        
        var rectTransform : CGAffineTransform!
        switch (self.imageOrientation)
        {
        case .Left:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(M_PI_2)), 0, -self.size.height)
        case .Right:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-CGFloat(M_PI_2)), -self.size.width, 0)
        case .Down:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-CGFloat(M_PI)), -self.size.width, -self.size.height)
        default:
            rectTransform = CGAffineTransformIdentity
        }
        
        rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
        
        let imageRef : CGImageRef = CGImageCreateWithImageInRect(self.CGImage!, CGRectApplyAffineTransform(rect, rectTransform))!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped : UIImage = UIImage(CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return cropped
    }
    
    func merge(image: UIImage, alpha: CGFloat) -> UIImage {
        print("Merge 2 images ...")
        let size = self.size
        print("Size 1 = \(size), size 2 = \(image.size)")
        print("Scale 1 = \(self.scale), scale 2 = \(image.scale)")
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        drawAtPoint(CGPointZero)
        image.drawAtPoint(CGPointZero, blendMode: .Normal, alpha: alpha)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func resize(newSize: CGSize) -> UIImage {
        let imageScale = min(newSize.width / size.width, newSize.height / size.height)
        if imageScale >= 1 {
            return self
        }
        
        let aspectSize = CGSizeMake(size.width * imageScale, size.height * imageScale)
        let hasAlpha = false
        
        UIGraphicsBeginImageContextWithOptions(aspectSize, !hasAlpha, scale)
        drawInRect(CGRect(origin: CGPointZero, size: aspectSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
